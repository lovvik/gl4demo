#version 330


uniform vec2 u_resolution;

out vec4 fragColor;

void main(void){
    vec2 pos = (2.0 * gl_FragCoord.xy - u_resolution) / min(u_resolution.x, u_resolution.y);
    //vec2 pos = vec2(.0);
    fragColor = vec4(pos.x, pos.y, 0.2, 1.0);
}