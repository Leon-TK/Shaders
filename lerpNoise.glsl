//Lerping particles

#extension GL_OES_standard_derivatives : enable

precision highp float;

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define BONE_COUNT 80

//Some hash function form the internet
vec2 hash21(float p)
{
	vec3 p3 = fract(vec3(p) * vec3(.1031, .1030, .0973));
	p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.xx+p3.yz)*p3.zy);
}

	
const vec4 background = vec4(.1, .1, .0, 1.);
const float pWidth = 0.001;

//Can use "mix"
vec2 lerp(in vec2 a, in vec2 b, in float alpha)
{ 
	return (b - a) * alpha + a;
}
	
void main( void ) {

	vec2 uv = gl_FragCoord.xy / resolution.xy;
	
	vec4 pColor = vec4(.8, .6, .6, 1.); //vec4(clamp(sin(time * 0.95), 0., 1.), clamp(cos(time), 0., 1.), .8, 1.);
	
	vec2 aPoints1[BONE_COUNT];
	vec2 aPoints2[BONE_COUNT];
	vec2 sPoints1[BONE_COUNT];
	vec2 sPoints2[BONE_COUNT];
	
	vec4 color;
	
	//Background
	color += background;
	
	//Note - "Bone" is old name
	for (int i = 0; i < BONE_COUNT; ++i)
	{
		//Get static postions
		vec2 noise1 = hash21(float(i));
		sPoints1[i] = noise1;
		sPoints2[i] = noise1 + 20.23;
		
		//Get animated positions
		aPoints1[i] = hash21(float(i) * time * 0.00005);
		aPoints2[i] = hash21(float(i) * time * 0.00002);
		
		//Lerp to static bones
		float sin1 = sin(time);
		aPoints1[i] = lerp(aPoints1[i], sPoints1[i], sin1);
		aPoints2[i] = lerp(aPoints2[i], sPoints2[i], sin1 + 10.);
		
		//check if uv is at point
		vec2 diffA = vec2(abs(uv.x - aPoints1[i].x), abs(uv.y - aPoints1[i].y));
		vec2 diffB = vec2(abs(uv.x - aPoints1[i].x), abs(uv.y - aPoints1[i].y));
		
		vec2 diffA2 = vec2(abs(uv.x - aPoints2[i].x), abs(uv.y - aPoints2[i].y));
		vec2 diffB2 = vec2(abs(uv.x - aPoints2[i].x), abs(uv.y - aPoints2[i].y));
		
		//TODO: Should I use math instead of bitwise operations?
		if (diffA.x < pWidth && diffA.y < pWidth || diffB.x < pWidth && diffB.y < pWidth || diffA2.x < pWidth && diffA2.y < pWidth || diffB2.x < pWidth && diffB2.y < pWidth)
		{
			color += pColor;
		}
	}
	

	
	gl_FragColor = color;

}