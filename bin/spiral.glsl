#version 330


precision highp float;

out vec4 fragColor ;

uniform vec2 u_resolution;
uniform float u_time;

float a = 10., b= 10.;

void main(void){
    vec2 pos = (2.0 * gl_FragCoord.xy - u_resolution) / min(u_resolution.x, u_resolution.y);

    vec3 color = vec3(.0);

    float angle = atan(-pos.y, pos.x)*0.1;

    float len = length(pos - vec2(.0));

    //float a = 10., b = 10.;

    /*ref
    color = vec3 (sin(len*50. + angle * 50. + u_time*5.));
    */

    color = vec3 (sin(len*a + angle * b + u_time*5.));


    // le multiple de 10. ici demultiplie le nombre de branches partant du centre 
    //faire varier le coeff a la position de 50 aussi donne des effets interessants

    //fragColor = vec4(color.x+pos.y, color.x+pos.x,color.x, 1.);
    /*if(mod(u_time, 100)==0.)a += 10.;
    if(mod(u_time, 100)==0.)b += 10.;*/
    b+=u_time/10.;

    fragColor = vec4(color, 1.);
}