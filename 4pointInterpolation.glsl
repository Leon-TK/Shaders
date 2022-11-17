//lerp between 4 positions
//Move mouse

#extension GL_OES_standard_derivatives : enable

precision highp float;

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

const vec4 background = vec4(.1, .1, .0, 1.);
const vec4 pColor = vec4(.8, .8, .8, 1.);
const float pWidth = 0.01;

//TODO: Use mix instead
vec2 lerp(vec2 a, vec2 b, float alpha)
{ 
	return (b - a) * alpha + a;
}

float lerpf(float a, float b, float alpha)
{
	return (b - a) * alpha + a;
}

void main( void ) {

	vec2 uv = gl_FragCoord.xy / resolution.xy;
	
	vec2 point;
	vec2 staticPoint4 = vec2(1.,1.);
	vec2 staticPoint3 = vec2(0.,1.);
	vec2 staticPoint2 = vec2(1.,0.);
	vec2 staticPoint1 = vec2(0.,0.);

	
	float interpPointCount = 3.;
	
	//1/3
	if (mouse.x < 1. / interpPointCount){
		point = lerp(staticPoint1, staticPoint2, clamp(lerpf(.0, interpPointCount, mouse.x), .0, 1.));
	}
	//2/3
	if (mouse.x > 1. / interpPointCount && mouse.x < 1. / interpPointCount * 2.){ // * instead of &&?
		point = lerp(staticPoint2, staticPoint3, clamp(lerpf(.0, interpPointCount, mouse.x - 1. / interpPointCount), .0, 1.));	
	}
	//3/3
	if (mouse.x > 1. / interpPointCount * 2.){
		point = lerp(staticPoint3, staticPoint4, clamp(lerpf(.0, interpPointCount, mouse.x - 1. / interpPointCount * 2.), .0, 1.));	
	}
	
	vec4 color;
	
	color += background;
	
	vec2 diff = abs(uv - point);
	
	
	//Check UV for intersection
	if (diff.x <= pWidth * resolution.y / resolution.x && diff.y <= pWidth)
	{

		color += pColor;
	}
	
	gl_FragColor = color;

}