#include "ReShade.fxh"
#include "ReShadeUI.fxh"

uniform float AmplR < __UNIFORM_SLIDER_FLOAT1
	ui_label = "UselessColorThresh"; ui_min = 0.0; ui_max = 100.0;
> = float(1.0);

uniform float AmplG < __UNIFORM_SLIDER_FLOAT1
	ui_label = "UselessColorThresh"; ui_min = 0.0; ui_max = 100.0;
> = float(1.0);

uniform float AmplB < __UNIFORM_SLIDER_FLOAT1
	ui_label = "UselessColorThresh"; ui_min = 0.0; ui_max = 100.0;
> = float(1.0);

float3 MainPass(float4 position : SV_Position, float2 texcoord : TexCoord) : SV_Target
{
	float3 color = tex2D(ReShade::BackBuffer, texcoord).rgb;
	return float3(ddx(color.r), color.g, color.b);
}
technique Test
{
	pass
	{
		VertexShader = PostProcessVS;
		PixelShader = MainPass;
	}
}