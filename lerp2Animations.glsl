//Move mouse
//Lerp between 2 points that are moving in different direction
#extension GL_OES_standard_derivatives : enable

precision highp float;

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

#define BONE_COUNT 40

//Some hash form the internet
vec2 hash21(float p)
{
	vec3 p3 = fract(vec3(p) * vec3(.1031, .1030, .0973));
	p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.xx+p3.yz)*p3.zy);

}
	
const vec4 background = vec4(.1, .1, .0, 1.);
const vec4 pColor = vec4(.8, .8, .8, 1.);
const float pWidth = 0.001;

//Can use "mix" instead
vec2 lerp(vec2 a, vec2 b, float alpha)
{ 
	return (b - a) * alpha + a;
}
	
void main( void ) {

	vec2 uv = gl_FragCoord.xy / resolution.x;
	
	vec2 point;
	vec2 staticPoint = vec2 (.5 , .25);
	
	staticPoint.x = cos(time * 4.) / 5. + .5;
	staticPoint.y = sin(time * 4.) / 5. + .25;
	
	
	point.x = sin(time * 4.) / 5. + .5;
	point.y = cos(time * 4.) / 5. + .25;
	
	point = lerp(point, staticPoint, mouse.x);
	
	vec4 color;
	
	color += background;
	
	vec2 diff = abs(uv - point);
	
	//Should I use * insted of &&?
	if (diff.x <= pWidth && diff.y <= pWidth)
	{

		color += pColor; //* clamp(cos(time), 0., 1.) + background * clamp(cos(time), 0., 1.);
	}
	
	gl_FragColor = color;

}