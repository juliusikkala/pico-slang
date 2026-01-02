import pico;
import st7789;

float3 viridisQuintic(float x)
{
	x = saturate(x);
	float4 x1 = float4(1.0, x, x * x, x * x * x);
	float4 x2 = x1 * x1.w * x;
	return saturate(float3(
		dot(x1.xyzw, float4(+0.280268003, -0.143510503, +2.225793877, -14.815088879)) + dot(x2.xy, float2(+25.212752309, -11.772589584)),
		dot(x1.xyzw, float4(-0.002117546, +1.617109353, -1.909305070, +2.701152864)) + dot(x2.xy, float2(-1.685288385, +0.178738871)),
		dot(x1.xyzw, float4(+0.300805501, +2.614650302, -12.019139090, +28.933559110)) + dot(x2.xy, float2(-33.491294770, +13.762053843))));
}

float3 renderPixel(float2 uv, float time)
{
    float2 p0 = uv.yx * float2(2.47, 2.24) - float2(2.0, 1.12);
    float2 p = float2(0);

    int i;
    const int N = 16;
    for(i = 0; p.x*p.x + p.y*p.y < 4 && i < N; ++i)
        p = float2(p.x*p.x - p.y*p.y, 2 * p.x * p.y) + p0;

    return viridisQuintic(float(i)*(1.0/float(N)));
}

static const int TILE_SIZE = 16;
static const int2 DISPLAY_SIZE = int2(240, 320);
static const float2 PIXEL_SIZE = 1.0 / float2(DISPLAY_SIZE);
static const float BAYER_4X4[4*4] = {
    0.000000, 0.500000, 0.125000, 0.625000,
    0.750000, 0.250000, 0.875000, 0.375000,
    0.187500, 0.687500, 0.062500, 0.562500,
    0.937500, 0.437500, 0.812500, 0.312500
};

float dither(int x, int y)
{
    return BAYER_4X4[(x&3) | ((y&3)<<2)];
}

uint16_t toRGB565(float3 color, float d)
{
    return (uint16_t(clamp(floor(color.r * 31 + d), 0.0, 31.0))<<11)|
        (uint16_t(clamp(floor(color.g * 62 + 2*d), 0.0, 63.0))<<5)|
        uint16_t(clamp(floor(color.b * 31 + d), 0.0, 31.0));
}

static uint16_t tileBuffer[TILE_SIZE * TILE_SIZE];

void renderTileBuffer(int2 tile, float time)
{
    float2 o = float2(tile * TILE_SIZE) * PIXEL_SIZE;
    float2 p;

    p.y = o.y;
    for (int y = 0; y < TILE_SIZE; ++y)
    {
        p.x = o.x;
        for (int x = 0; x < TILE_SIZE; ++x)
        {
            float3 color = renderPixel(p, time);
            float d = dither(x, y);
            tileBuffer[x + y * TILE_SIZE] = toRGB565(color, d);
            p.x += PIXEL_SIZE.x;
        }
        p.y += PIXEL_SIZE.y;
    }
}

void renderFrame(inout ST7789 display, float time)
{
    int2 tileCount = DISPLAY_SIZE / TILE_SIZE;

    for (int tileX = 0; tileX < tileCount.x; ++tileX)
    for (int tileY = 0; tileY < tileCount.y; ++tileY)
    {
        renderTileBuffer(int2(tileX, tileY), time);
        display.writeTile(tileX * TILE_SIZE, tileY * TILE_SIZE, TILE_SIZE, TILE_SIZE, Ptr<uint16_t>(&tileBuffer));
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

    for (int i = 0;; ++i)
    {
        float time = pico.to_ms_since_boot(pico.get_absolute_time()) * 0.001f;
        renderFrame(display, time);
        printf("It's ON\n");
        pico.cyw43_arch_gpio_put(pico.CYW43_WL_GPIO_LED_PIN, bool(i&1));
        pico.sleep_ms(16);
    }
    return 0;
}
