//Filters analogous shades by user defined main color.

#extension GL_OES_standard_derivatives : enable

precision mediump float;

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

//For test

//Turn to black-white
vec4 Monochrome(vec4 color)
{
	vec4 mRed = color.rrra;
	vec4 mGreen = color.ggga;
	vec4 mBlue = color.bbba;
	vec4 avrg = (mRed + mGreen + mBlue) / 3.;
	return avrg;
}
	
bool isChannelDominant(float mainCh, float other, float other2)
{
	if (mainCh > other && mainCh > other2) //TODO: change to "*" instead of &&?
	{
		return true;
	}
	return false;
}

vec3 FilterExceptR(vec3 color)
{
	return vec3(color.r, 0.0, 0.0);
}

vec3 FilterExceptG(vec3 color)
{
	return vec3(0.0, color.g, 0.0);
}

vec3 FilterExceptB(vec3 color)
{
	return vec3(0.0, 0.0, color.b);
}

vec4 GetOnlyW(vec4 color, float diffThresh)
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
		return vec4(0.);
	}
	
}

vec4 getRedBlack(vec2 coord)
{
	return vec4(coord.x, 0.,0.,1.);
}

vec4 getRedWhite(vec2 coord)
{
	return vec4(1., coord.x, coord.x, 1.);
}

vec4 getBlueWhite(vec2 coord)
{
	return vec4(coord.x, coord.x, 1.,1.);
}

vec4 getBlueBlack(vec2 coord)
{
	return vec4(0., 0., coord.x, 1.);
}

vec4 getGreenWhite(vec2 coord)
{
	return vec4(coord.x, 1., coord.x,1.);
}

vec4 getGreenBlack(vec2 coord)
{
	return vec4(0., coord.x, 0. ,1.);
}
//~For test

vec4 ExtractRedShades(vec4 color, float analogousRange, float lightShadesCut, float darkShadesCut)
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
	return vec4(0.);
}

vec4 ExtractGreenShades(vec4 color, float analogousRange, float lightShadesCut, float darkShadesCut)
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
	return vec4(0.);
}

vec4 ExtractBlueShades(vec4 color, float analogousRange, float lightShadesCut, float darkShadesCut)
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
	return vec4(0.);
}

void main( void ) {
	
	float AnalogousRange = 1.; //how much analogous colors to take in
	float LightShadeCut = 0.;
	float DarkShadeCut = 0.;
	
	//Which shade to extract
	//0 - red, 1 - green, 2 - blue, 3 - no filter
	int Combo_ColorToExtract = 0;
	
	
	//Fill by gradient
	vec2 pixPos = gl_FragCoord.xy / resolution;
	vec4 color = getRedBlack(pixPos); //choose colors

	if (Combo_ColorToExtract == 0) {gl_FragColor = ExtractRedShades(color, AnalogousRange, LightShadeCut, DarkShadeCut);}
	if (Combo_ColorToExtract == 1) {gl_FragColor = ExtractGreenShades(color, AnalogousRange, LightShadeCut, DarkShadeCut);}
	if (Combo_ColorToExtract == 2) {gl_FragColor = ExtractBlueShades(color, AnalogousRange, LightShadeCut, DarkShadeCut);}
	if (Combo_ColorToExtract == 3) {gl_FragColor = color;}
	
	//gl_FragColor = color;
}