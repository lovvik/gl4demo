#version 330

precision mediump float;
uniform sampler2D myTexture;

uniform vec2 u_resolution;
uniform float u_time;

out vec4 fragColor;

void main(void){
    vec2 uv =  gl_FragCoord.xy/-(u_resolution.xy);

   
    //uv*=-1.;
    uv.x*=-1.;
    vec3 color = texture(myTexture, uv).xyz;
    
    fragColor = vec4(color, 1.0);
}