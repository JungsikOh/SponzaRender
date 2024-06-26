#include "Common.hlsli"

struct SkyboxPixelShaderInput
{
    float4 posProj : SV_Position;
    float3 posModel : Positon;
};

struct PSOutput
{
    float4 pixelColor : SV_Target0;
};

PSOutput main(SkyboxPixelShaderInput input)
{
    PSOutput output;
    
    if (textureToDraw == 0)
        output.pixelColor = envIBLTex.SampleLevel(linearWrapSampler, input.posModel.xyz, envLodBias);
    else if (textureToDraw == 1)
        output.pixelColor = specularIBLTex.SampleLevel(linearWrapSampler, input.posModel.xyz, envLodBias);
    else if (textureToDraw == 2)
        output.pixelColor = irradianceIBLTex.SampleLevel(linearWrapSampler, input.posModel.xyz, envLodBias);
    else
        output.pixelColor = float4(135 / 255, 206 / 255, 235 / 255, 1);

    output.pixelColor *= strengthIBL;
	return output;
}