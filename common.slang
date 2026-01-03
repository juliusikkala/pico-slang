static const int DISPATCH_TILE_SIZE = 16;

struct ShadertoyConstants
{
	float time;
    int frame;
    float pad[2];
    float4 mouse;
    float3 res;
}
