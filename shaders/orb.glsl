#version 330


precision highp float;

out vec4 fragColor ;

uniform vec2 u_resolution;
uniform float u_time;

float circleSDF(in vec2 st, in vec2 center) {
    return length(st - center) * 2.;
}


void main(){
    vec2 pos = (2.0 * gl_FragCoord.xy - u_resolution) / min(u_resolution.x, u_resolution.y);

    // jsute  avec la valeur de 3.0 au lieu du noir, on a un resultat niiiice
    vec3 color = vec3(3.0);

    float angle = atan(-pos.y, pos.x)*0.1;

    float len = length(pos - vec2(.0));


    color.r += sin(len*50. + angle * 20. + cos(u_time)*u_time);

    color.g += cos(len*6. + angle * 30. - sin(u_time)*u_time);

    color.b += sin(len*sin(u_time) + angle * 40. - u_time);



    color *= mix(color, vec3(.1), circleSDF(pos, vec2(.0))); // un peu bulle cosmique (1)

    //differents mix et tres bien ensemble aussi


    //color = mix (vec3(.7), color, 1.-color);

    //color *= mix (vec3(.7), color, 1.-color);

    //color += mix (vec3(.7), color, 1.-color);

    fragColor = vec4(color, 1.);

}