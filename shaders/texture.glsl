#version 330

uniform vec2 u_resolution;
uniform float u_time;

in vec2 v_textcoord;
uniform sampler2D u_texture;

out vec4 fragColor;



void main(void){
    vec2 pos = (2.0 * gl_FragCoord.xy - u_resolution) / min(u_resolution.x, u_resolution.y);


    fragColor = texture(u_texture, v_textcoord);
}