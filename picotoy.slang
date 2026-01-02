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

__extern_cpp void runnerMain_Group(ComputeVaryingInput*, void*, RunnerGlobalParams*);

static const int2 DISPLAY_SIZE = int2(240, 320);

static uint16_t tileBuffer[DISPATCH_TILE_SIZE * DISPATCH_TILE_SIZE];
static ShadertoyConstants constants = {};

void renderTileBuffer(int2 tile)
{
    ComputeVaryingInput varying;
    varying.startGroupID = uint3(tile.yx, 0);
    varying.endGroupID = varying.startGroupID;

    RunnerGlobalParams params;
    params.constants = &constants;
    params.tileData = Ptr<uint16_t>(&tileBuffer);
    params.tileDataSize = DISPATCH_TILE_SIZE * DISPATCH_TILE_SIZE;

    runnerMain_Group(&varying, nullptr, &params);
}

void renderFrame(inout ST7789 display)
{
    int2 tileCount = DISPLAY_SIZE / DISPATCH_TILE_SIZE;

    for (int tileX = 0; tileX < tileCount.x; ++tileX)
    for (int tileY = 0; tileY < tileCount.y; ++tileY)
    {
        renderTileBuffer(int2(tileX, tileY));
        display.writeTile(tileX * DISPATCH_TILE_SIZE, tileY * DISPATCH_TILE_SIZE, DISPATCH_TILE_SIZE, DISPATCH_TILE_SIZE, Ptr<uint16_t>(&tileBuffer));
    }
}

export __extern_cpp int main()
{
    pico.stdio_init_all();
    if (pico.cyw43_arch_init() != 0)
        printf("Failed to init Wi-Fi module\n");
    
    ST7789 display = ST7789(
        pico.SPI0, DISPLAY_SIZE.x, DISPLAY_SIZE.y,
        pico.PICO_DEFAULT_SPI_TX_PIN,
        pico.PICO_DEFAULT_SPI_SCK_PIN,
        pico.PICO_DEFAULT_SPI_CSN_PIN,
        21,
        20
    );

    display.init();

    uint64_t startTime = pico.to_ms_since_boot(pico.get_absolute_time());
    constants.mouse = float4(0);
    constants.res = float3(DISPLAY_SIZE.yx, 1);

    for (int i = 0;; ++i)
    {
        constants.time = float(pico.to_ms_since_boot(pico.get_absolute_time()) - startTime) * 1e-3;
        constants.frame = i;

        renderFrame(display);
        pico.cyw43_arch_gpio_put(pico.CYW43_WL_GPIO_LED_PIN, bool(i&1));
    }
    return 0;
}
