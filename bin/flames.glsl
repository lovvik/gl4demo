#version 330


precision highp float;

out vec4 fragColor ;

uniform vec2 u_resolution;
uniform float u_time;






void main(void){
    vec2 pos = (2.0 * gl_FragCoord.xy - u_resolution) / min(u_resolution.x, u_resolution.y);


    vec3 color = vec3(.0);

    color+=sin((pos.x+1.)*50. + cos(u_time+pos.y * 10.0 + sin(pos.x*50.0+u_time*2.)) ) * 2.0;

    color+=cos((pos.x+1.)*20. + sin(u_time+pos.y * 10.0 + cos(pos.x*50.0+u_time*2.)) ) * 2.0;

    color+=sin((pos.x+1.)*30. + cos(u_time+pos.y * 10.0 + sin(pos.x*50.0+u_time*2.)) ) * 2.0;

    color+=cos((pos.x+1.)*10. + sin(u_time+pos.y * 10.0 + cos(pos.x*50.0+u_time*2.)) ) * 2.0;

    fragColor = vec4(color.x+pos.y, color.x+pos.x,color.x, 1.);

}