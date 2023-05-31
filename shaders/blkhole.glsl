#version 330

precision mediump float;
uniform sampler2D myTexture;

uniform vec2 u_resolution;
uniform float u_time;

out vec4 fragColor;

void main(void){
    vec2 uv = gl_FragCoord.xy/u_resolution.xy;
    uv = gl_FragCoord.xy/u_resolution.xy;

    float size = .25; /*prev 0.41*/
    
    float mask = smoothstep(1.,.061, length(uv-.5)); 
    
    vec2 blkhole = normalize(uv-vec2(.5))*size;
    
    
    
    blkhole+=vec2(sin(u_time*.3), cos(u_time*.3));

    uv.x-=.3;
    vec3 color = texture(myTexture, uv-blkhole).xyz;

    color = mix(vec3(.0), color, smoothstep(0.,.7, length(uv-.5)));

    
    fragColor = vec4(color, 1.0);
}