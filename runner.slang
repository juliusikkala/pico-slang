#include "common.slang"

ConstantBuffer<ShadertoyConstants> shadertoyConstants;

#define iResolution shadertoyConstants.res
#define iFrame shadertoyConstants.frame
#define iMouse shadertoyConstants.mouse
#define iTime shadertoyConstants.time

#ifndef PICOTOY_RUNNER_INCLUDE
#define PICOTOY_RUNNER_INCLUDE "shaders/a_dead_planet_of_silicon_dreams.glsl"
#endif
#include PICOTOY_RUNNER_INCLUDE

RWStructuredBuffer<uint16_t> tileData;

float dither(int x, int y)
{
    static const float BAYER_4X4[4*4] = {
        0.000000, 0.500000, 0.125000, 0.625000,
        0.750000, 0.250000, 0.875000, 0.375000,
        0.187500, 0.687500, 0.062500, 0.562500,
        0.937500, 0.437500, 0.812500, 0.312500
    };
    return BAYER_4X4[(x&3) | ((y&3)<<2)];
}

uint16_t toRGB565(float3 color, float d)
{
    color = saturate(color);
    return
        (uint16_t(floor(color.r * 31 + d))<<11)|
        (uint16_t(floor(color.g * 62 + 2*d))<<5)|
        (uint16_t(floor(color.b * 31 + d)));
}

[numthreads(DISPATCH_TILE_SIZE,DISPATCH_TILE_SIZE,1)]
void PICOTOY_RUNNER_MAIN(
    uint3 dispatchThreadID : SV_DispatchThreadID,
    uint3 groupThreadID : SV_GroupThreadID)
{
    float4 color = float4(1);
    mainImage(color, float2(dispatchThreadID.xy));
    float d = dither(groupThreadID.x, groupThreadID.y);
    tileData[groupThreadID.y + groupThreadID.x * DISPATCH_TILE_SIZE] = toRGB565(color.rgb, d);
}
