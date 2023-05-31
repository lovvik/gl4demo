#version 330

uniform vec2 u_resolution;
uniform float u_time;



out vec4 fragColor;



void main(void){
    vec2 pos = (2.0 * gl_FragCoord.xy - u_resolution) / min(u_resolution.x, u_resolution.y);

    vec3 color = vec3(.0);

    float t = u_time*0.01;

    color = vec3(smoothstep(.0, .3, length(pos + vec2(sin(t), cos(t)))*.1))+.4;

    fragColor = vec4(color, 1.);
}