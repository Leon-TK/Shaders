//Filters analogous shades by user defined main color.
#include "ReShade.fxh"
#include "ReShadeUI.fxh"

uniform float DarkShadeCut < __UNIFORM_SLIDER_FLOAT1
	ui_label = "Dark shade cut"; ui_min = 0.0; ui_max = 1.0;
	ui_tooltip = "How much dark shades to filter";
> = float(0.5);

uniform float LightShadeCut < __UNIFORM_SLIDER_FLOAT1
	ui_label = "Light shade cut"; ui_min = 0.0; ui_max = 1.0;
	ui_tooltip = "How much light shades to filter";
> = float(0.5);

uniform float AnalogousRange < __UNIFORM_SLIDER_FLOAT1
	ui_label = "Analogous shades range"; ui_min = 0.0; ui_max = 1.0;
	ui_tooltip = "Set how much analogous shades to not cut. For example R's analogous colors are Yellow-Orange and Red-Violet if 1. is set";
> = float(1.0);

uniform int Combo_ColorToExtract <
	ui_type = "combo";
	ui_label = "Color to show";
	ui_tooltip = "Choose which color to show. Analogous shades are included";
	ui_items = "R\0"
	           "G\0"
	           "B\0"
			   "None\0";
> = 3;

float4 ExtractRedShades(float4 color, float analogousRange, float lightShadesCut, float darkShadesCut) // other 0.0-0.5, channelThresh 0.5-1.0
{
	
	float sat = 1. - color.g;
	if (color.r >= color.b && color.r >= color.g)
	{
		float gbDiff = abs(color.b - color.g);
		if (gbDiff <= analogousRange)
		{
			if(sat >= lightShadesCut && color.r >= darkShadesCut)
			{
				return color;
			}
		}
	}
	return 0.;
}

float4 ExtractGreenShades(float4 color, float analogousRange, float lightShadesCut, float darkShadesCut)
{
	float sat = 1. - color.r;
	if (color.g >= color.r && color.g >= color.b)
	{
		float rbDiff = abs(color.r - color.b);
		if (rbDiff <= analogousRange)
		{
			if(sat >= lightShadesCut && color.g >= darkShadesCut)
			{
				return color;
			}
		}
	}
	return 0.;
}

float4 ExtractBlueShades(float4 color, float analogousRange, float lightShadesCut, float darkShadesCut)
{
	float sat = 1. - color.r;
	if (color.b >= color.r && color.b >= color.g)
	{
		float rgDiff = abs(color.r - color.g);
		if (rgDiff <= analogousRange)
		{
			if(sat >= lightShadesCut && color.b >= darkShadesCut)
			{
				return color;
			}
		}
	}
	return 0.;
}

float4 MainPass(float4 position : SV_Position, float2 texcoord : TexCoord) : SV_Target
{
	float2 uv = texcoord.xy / ReShade::ScreenSize.xy;
	float4 color = tex2D(ReShade::BackBuffer, texcoord).rgba;

	float4 filteredColor = color;
	
	if (Combo_ColorToExtract == 0) {filteredColor = ExtractRedShades(filteredColor, AnalogousRange, LightShadeCut, DarkShadeCut);}
	if (Combo_ColorToExtract == 1) {filteredColor = ExtractGreenShades(filteredColor, AnalogousRange, LightShadeCut, DarkShadeCut);}
	if (Combo_ColorToExtract == 2) {filteredColor = ExtractBlueShades(filteredColor, AnalogousRange, LightShadeCut, DarkShadeCut);}

	if (Combo_ColorToExtract == 3) { return color; }
	else { return filteredColor; }
}


technique ShadesFilter
{
	pass
	{
		VertexShader = PostProcessVS;
		PixelShader = MainPass;
	}
}

//For test
float3 FilterExceptR(float3 color)
{
	return float3(color.r, 0.0, 0.0);
}

float3 FilterExceptG(float3 color)
{
	return float3(0.0, color.g, 0.0);
}

float3 FilterExceptB(float3 color)
{
	return float3(0.0, 0.0, color.b);
}

float4 GetOnlyW(float4 color, float diffThresh)
{
	float diff1 = color.r - color.g;
	float diff2 = color.g - color.b;
	float diff3 = color.r - color.b;

	if(abs(diff1) < diffThresh && abs(diff2) < diffThresh && abs(diff3) < diffThresh)
	{ 
		return color;
	}
	else 
	{ 
		return 0.;
	}
	
}

float4 getRedBlack(float2 coord)
{
	return float4(coord.x, 0.,0.,1.);
}

float4 getRedWhite(float2 coord)
{
	return float4(1., coord.x, coord.x, 1.);
}

float4 getBlueWhite(float2 coord)
{
	return float4(coord.x, coord.x, 1.,1.);
}

float4 getBlueBlack(float2 coord)
{
	return float4(0., 0., coord.x, 1.);
}

float4 getGreenWhite(float2 coord)
{
	return float4(coord.x, 1., coord.x,1.);
}

float4 getGreenBlack(float2 coord)
{
	return float4(0., coord.x, 0. ,1.);
}
//~For test
