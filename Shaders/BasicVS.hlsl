#include "Common.hlsli"

Texture2D g_heightTexture : register(t0);

cbuffer MeshConstants : register(b0)
{
    matrix world;
    matrix worldIT;
    int useHeightMap;
    float heightScale;
    float dummy;
};

cbuffer InstancedConsts : register(b2)
{
    float3 instanceMat[MAX_INSTANCE];
    int useInstancing;
}

PixelShaderInput main(VertexShaderInput input)
{
    PixelShaderInput output;
    //Inverse: ���� ���ʹ� ǥ�鿡 �����̾�� �ϹǷ�, ��ȯ ����� �����ϸ��� ������ ���, �� �����ϸ��� ����ؾ� �մϴ�. �̸� ���� ���� ����� ������� ����մϴ�.
    //Transpose: ȸ������ �����ϰ� �����ϸ��� �����ϱ� ���� ������� ��ġ(transpose)�մϴ�. �̴� ���� ������� ����� ȸ�� ���и��� ������ �� ����ϴ� �Ϲ����� ����Դϴ�.
    // Translation Normal Vector(include Scale, Rotate) -> Don't include Scale Rotate coponents.
    float4 normal = float4(input.normalModel, 0.0f);
    output.normalWorld = mul(normal, worldIT).xyz;
    output.normalWorld = normalize(output.normalWorld);
    
    // Translate world space from tangent Vector
    float4 tangentWorld = float4(input.tangentModel, 0.0f);
    tangentWorld = mul(tangentWorld, world);
    
    if (useInstancing)
    {
        input.posModel += instanceMat[input.instanceID];
    }
    float4 pos = float4(input.posModel, 1.0f);
    pos = mul(pos, world);
    
    if (useHeightMap)
    {
        float height = g_heightTexture.SampleLevel(linearClampSampler, input.texcoord, 0).r;
        height = height * 2.0 - 1.0;
        pos += float4(output.normalWorld * height * heightScale, 0.0);
    }
    
    output.posWorld = pos.xyz;
    
    pos = mul(pos, viewProj);
    
    output.posProj = pos;
    output.texcoord = input.texcoord;
    output.tangentWorld = normalize(tangentWorld.xyz);
    
    return output;
  
}