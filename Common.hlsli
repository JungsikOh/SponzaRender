#ifndef __COMMON_HLSLI__
#define __COMMON_HLSLI__

#define MAX_LIGHTS 3
#define LIGHT_OFF 0x00
#define LIGHT_DIRECTIONAL 0x01
#define LIGHT_POINT 0x02
#define LIGHT_SPOT 0x04

// ���÷����� ��� ���̴����� �������� ���
SamplerState linearWrapSampler : register(s0);
SamplerState linearClampSampler : register(s1);

// ���� �ؽ��ĵ��� t10���� ����
TextureCube specularIBLTex : register(t10);
TextureCube irradianceIBLTex : register(t11);
TextureCube envIBLTex : register(t12);
Texture2D brdfTex : register(t13);


struct Light
{
    float3 radiance;
    float fallOffStart;
    float3 direction;
    float fallOffEnd;
    float3 position;
    float spotPower;
    float3 lightColor;
    float dummy1;
    
    uint type;
    float radius;
    float2 dummy;
    
    matrix viewProj;
    matrix invProj;
};

cbuffer GlobalConstants : register(b1)
{
    matrix view;
    matrix proj;
    matrix invProj;
    matrix viewProj;
    matrix invViewProj;
    float3 eyeWorld;
    float strengthIBL;
    
    int textureToDraw;
    float envLodBias;
    float lodBias;
    float dummy2;
    
    Light lights[MAX_LIGHTS];
};

struct VertexShaderInput
{
    float3 posModel : POSITION; //�� ��ǥ���� ��ġ position
    float3 normalModel : NORMAL0; // �� ��ǥ���� normal    
    float2 texcoord : TEXCOORD0;
    float3 tangentModel : TANGENT0;
};

struct PixelShaderInput
{
    float4 posProj : SV_POSITION; // Screen position
    float3 posWorld : POSITION; // World position (���� ��꿡 ���)
    float3 normalWorld : NORMAL0;
    float2 texcoord : TEXCOORD0;
    float3 tangentWorld : TANGENT0;
};

#endif // __COMMON_HLSLI__