import pico;
import st7789;
import common;

struct RunnerGlobalParams
{
    ShadertoyConstants* constants;
    uint16_t* tileData;
    size_t tileDataSize;
};

struct ComputeVaryingInput
{
    uint3 startGroupID;
    uint3 endGroupID;
};

#ifndef SHADER_COUNT
#define SHADER_COUNT 1
#endif

#ifndef SHADER_RUNNERS
#define SHADER_RUNNERS X(0)
#endif

#define X(index) __extern_cpp void runner##index##Main_Group(ComputeVaryingInput*, void*, RunnerGlobalParams*);
SHADER_RUNNERS
#undef X

static const int2 DISPLAY_SIZE = int2(240, 320);
static const int2 TILE_COUNT = DISPLAY_SIZE / DISPATCH_TILE_SIZE;
static const int LEFT_BUTTON_PIN = 15;
static const int RIGHT_BUTTON_PIN = 14;
static ST7789 display;

static ShadertoyConstants constants = {};
static int tileID = TILE_COUNT.x * TILE_COUNT.y;
static bool core1Finished = false;
static pico.mutex_t workerMutex = {};
static pico.mutex_t displayMutex = {};

static int shaderIndex = 0;
static int pendingShaderChange = 0;

bool checkButtons()
{
    static bool prevLeftDown = false;
    static bool prevRightDown = false;
    bool leftDown = pico.gpio_get(LEFT_BUTTON_PIN) == 0;
    bool rightDown = pico.gpio_get(RIGHT_BUTTON_PIN) == 0;

    if (leftDown && !prevLeftDown)
        pendingShaderChange = -1;
    if (rightDown && !prevRightDown)
        pendingShaderChange = 1;

    prevLeftDown = leftDown;
    prevRightDown = rightDown;
    return pendingShaderChange != 0;
}

Optional<int2> acquireTile()
{
    bool fail = false;
    pico.mutex_enter_blocking(&workerMutex);
    if (tileID >= TILE_COUNT.x * TILE_COUNT.y)
        fail = true;
    int id = tileID++;
    if (checkButtons())
        fail = true;
    pico.mutex_exit(&workerMutex);

    if (fail)
        return none;

    return int2(id / TILE_COUNT.y, id % TILE_COUNT.y);
}

void setOverclock()
{
    // Starting with modest overclock.
    pico.set_sys_clock_khz(532000, true);
}

void renderTile(int2 tile)
{
    uint16_t tileBuffer[DISPATCH_TILE_SIZE * DISPATCH_TILE_SIZE];

    ComputeVaryingInput varying;
    varying.startGroupID = uint3(tile.yx, 0);
    varying.endGroupID = varying.startGroupID;

    RunnerGlobalParams params;
    params.constants = &constants;
    params.tileData = Ptr<uint16_t>(&tileBuffer);
    params.tileDataSize = DISPATCH_TILE_SIZE * DISPATCH_TILE_SIZE;

    switch(shaderIndex)
    {
    #define X(index) \
        case index: runner##index##Main_Group(&varying, nullptr, &params); break;
    SHADER_RUNNERS
    #undef X
    default:
        break;
    }

    pico.mutex_enter_blocking(&displayMutex);
    display.writeTile(
        tile.x * DISPATCH_TILE_SIZE,
        tile.y * DISPATCH_TILE_SIZE,
        DISPATCH_TILE_SIZE,
        DISPATCH_TILE_SIZE,
        Ptr<uint16_t>(&tileBuffer));
    pico.mutex_exit(&displayMutex);
}

void core1Worker()
{
#ifdef OVERCLOCK
    setOverclock();
#endif

    for (;;)
    {
        Optional<int2> tile = acquireTile();
        if (tile.hasValue)
        {
            renderTile(tile.value);
        }
        else
        {
            pico.mutex_enter_blocking(&workerMutex);
            core1Finished = true;
            pico.mutex_exit(&workerMutex);
        }
    }
}

void* funcPtr<T>(T worker)
{
    __intrinsic_asm "ret $0";
}

void renderFrame()
{
    pico.mutex_enter_blocking(&workerMutex);
    tileID = 0;
    pendingShaderChange = 0;
    pico.mutex_exit(&workerMutex);

    for (;;)
    {
        Optional<int2> tile = acquireTile();
        if (!tile.hasValue)
            break;

        renderTile(tile.value);
    }

    pico.mutex_enter_blocking(&workerMutex);
    core1Finished = false;
    pico.mutex_exit(&workerMutex);

    // Stall while worker is running
    for (;;)
    {
        pico.mutex_enter_blocking(&workerMutex);
        if (core1Finished)
        {
            pico.mutex_exit(&workerMutex);
            break;
        }
        pico.mutex_exit(&workerMutex);
        pico.sleep_us(10);
    }
}

void poke(uint address, uint value)
{
    *reinterpret<Ptr<uint>>(address) = value;
}

void adjustVoltage()
{
    // https://gist.github.com/MichaelBell/c413356f4c45bf9aef98cd23ceb83057
    poke(0x4010001c, 0x5AFE0091);
    pico.sleep_ms(100);
    poke(0x400d000c, 0x60007304);
    poke(0x40100004, 0x5AFEA150);

    pico.vreg_set_voltage(pico.VREG_VOLTAGE_1_60);
    pico.sleep_ms(100);
}

export __extern_cpp int main()
{
#ifdef OVERCLOCK
    adjustVoltage();
    setOverclock();
#endif

    pico.stdio_init_all();

    pico.mutex_init(&workerMutex);
    pico.mutex_init(&displayMutex);
    
    display = ST7789(
        pico.SPI0, DISPLAY_SIZE.x, DISPLAY_SIZE.y,
        pico.PICO_DEFAULT_SPI_TX_PIN,
        pico.PICO_DEFAULT_SPI_SCK_PIN,
        pico.PICO_DEFAULT_SPI_CSN_PIN,
        21,
        20
    );
    display.init();

    pico.gpio_init(LEFT_BUTTON_PIN);
    pico.gpio_init(RIGHT_BUTTON_PIN);
    pico.gpio_set_dir(LEFT_BUTTON_PIN, false);
    pico.gpio_set_dir(RIGHT_BUTTON_PIN, false);
    pico.gpio_pull_up(LEFT_BUTTON_PIN);
    pico.gpio_pull_up(RIGHT_BUTTON_PIN);

    pico.multicore_reset_core1();
    pico.multicore_launch_core1(funcPtr(core1Worker));

    uint64_t startTime = pico.to_ms_since_boot(pico.get_absolute_time());
    constants.mouse = float4(0);
    constants.res = float3(DISPLAY_SIZE.yx, 1);
    constants.frame = 0;
    constants.time = 0;

    for (int i = 0;; ++i)
    {
        float prev_time = constants.time;
        constants.time = float(pico.to_ms_since_boot(pico.get_absolute_time()) - startTime) * 1e-3;

        printf("Frame %d: %f s (avg: %f s)\n", constants.frame, constants.time - prev_time, constants.time / float(constants.frame));

        renderFrame();

        constants.frame++;
        
        if (pendingShaderChange != 0)
        {
            shaderIndex = shaderIndex + (pendingShaderChange < 0.0 ? SHADER_COUNT+pendingShaderChange : pendingShaderChange);
            shaderIndex %= SHADER_COUNT;
            startTime = pico.to_ms_since_boot(pico.get_absolute_time());
            constants.frame = 0;
        }
    }
    return 0;
}
