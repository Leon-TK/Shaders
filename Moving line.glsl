#extension GL_OES_standard_derivatives : enable

precision highp float;

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;


void main( void ) {
	//Setup UV with aspect ratio
	vec2 pixPos = gl_FragCoord.xy / resolution;

	float width = 1.;
	float offset = 0.5; //animation offset from left side
	float ampl = 0.5; //amplitude of animation
	float speed = 2.;
	
	
	//Using cosine formula and it's constants (math :))
	float alpha = clamp(cos(time * speed) * ampl + offset, 0., 1.);
	
	float posX = mix(0., resolution.x, alpha); //lerp by alpha
	
	float diff = abs(posX - gl_FragCoord.x); //Check how much pixel is near to calculated value
	
	//Fill pixel by color
	if (diff < 1.) {
		gl_FragColor = vec4 (alpha, 1. - alpha, 0., 1.); }
	
}