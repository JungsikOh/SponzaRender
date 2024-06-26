#include "Common.hlsli"

Texture2D g_heightTexture : register(t0);

cbuffer MeshConstants : register(b0)
{
    matrix world;
    matrix worldIT;
    int useHeightMap;
    float heightScale;
    float2 dummy;
};

cbuffer InstancedConsts : register(b2)
{
    float3 instancePos[5];
    int useInstancing;
}

struct VSInstancedInput
{
    float3 posModel : POSITION; //�� ��ǥ���� ��ġ position
    float3 normalModel : NORMAL0; // �� ��ǥ���� normal    
    float2 texcoord : TEXCOORD0;
    float3 tangentModel : TANGENT0;
    uint instanceID : SV_InstanceID;
};

PixelShaderInput main(VSInstancedInput input)
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
    
    input.posModel += instancePos[input.instanceID % 5];
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