#version 330

precision mediump float;

uniform vec2 u_resolution;
uniform float u_time;

out vec4 fragColor;


vec3 palette( in float t)
{   
    vec3 a = vec3(0.5, 0.5, 0.5);
    vec3 b = vec3(.5, 0.5, 0.5);
    vec3 c = vec3(1.0, 0.7, 0.4);
    vec3 d = vec3(0.00, 0.15, 0.20);
    return a + b*cos( 6.28318*(c*t+d) );
}





void main(){
    vec2 pos = (2.0 * gl_FragCoord.xy - u_resolution) / min(u_resolution.x, u_resolution.y);

   vec3 color = vec3(.0);

   color+=sin((pos.x+1.)*50. + cos(u_time+pos.y + 10.0 * sin(pos.x*50.0)) ) * 2.0;
   color*=palette(u_time*pos.y*.03);



    fragColor = vec4(color, 1.);

}