#extension GL_OES_standard_derivatives : enable

precision highp float;

uniform float time;
uniform vec2 mouse;
uniform vec2 resolution;

void main( void ) {
	//Do some stuff on UV
	vec2 p = 2.0*( gl_FragCoord.xy / resolution.xy ) + mouse - 1.5;
	vec3 col = vec3(0);
	
	//Creepy magic
	col += vec3(1)*1.0/(1.0+50.0*abs(p.y+sin(p.x*10.0)*cos(time*2.))); 
	col += vec3(1)*1.0/(1.0+50.0*abs(p.y+sin(p.x*10.0+3.1415)*cos(time))); 
	
	gl_FragColor = vec4(col, 1.0);
}