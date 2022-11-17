#include "ReShade.fxh"
#include "ReShadeUI.fxh"

float3 MainPass(float4 position : SV_Position, float2 texcoord : TexCoord) : SV_Target
{
	float3 color = tex2D(ReShade::BackBuffer, texcoord).xyz;
	//TODO: Use clamp?
	if (color.x > 1.0) {color.x = 1.0;}
	if (color.x < 0.0) {color.x = 0.0;}
	if (color.y > 1.0) {color.y = 1.0;}
	if (color.y < 0.0) {color.y = 0.0;}
	if (color.z > 1.0) {color.z = 1.0;}
	if (color.z < 0.0) {color.z = 0.0;}
	float3 sum = color.xxx + color.yyy + color.zzz;
	float3 avg = sum.xyz / 3;
	return avg.xyz; //overcompl for test
}
technique Monochrome
{
	pass
	{
		VertexShader = PostProcessVS;
		PixelShader = MainPass;
	}
}