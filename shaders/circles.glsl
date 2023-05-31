#version 330


precision highp float;

out vec4 fragColor ;

uniform vec2 u_resolution;
uniform float u_time;

vec3 palette( in float t)
{   
    vec3 a = vec3(0.808, 0.178, 0.718);
    vec3 b = vec3(0.659, 0.438, 1.368);
    vec3 c = vec3(0.388 ,0.388 ,0.358);
    vec3 d = vec3(2.826, 2.766, 2.647);

    /*vec3 a = vec3(0.5, 0.5, 0.5	);
    vec3 b = vec3(0.5, 0.5, 0.5);
    vec3 c = vec3(	1.0, 1.0, 1.0);
    vec3 d = vec3(0.30, 0.20, 0.20);*/


    return a + b*cos( 6.28318*(c*t+d) );
}

float mycircle(vec2 centre, float size, in vec2 pos){
    return 1.-step(size, distance(pos, centre));
}

float sdCircle( vec2 p, float r )
{
    return length(p) - r;
}




void main(){
    vec2 pos = (2.0 * gl_FragCoord.xy - u_resolution) / min(u_resolution.x, u_resolution.y);

    vec2 pos0 = pos;

    vec3 fcol = vec3(.0);

    for (int i=0; i<1; i++){
        pos = fract(pos * 5.) - .5;

        float d = length(pos) * sin(-length(pos0));
        vec3 coul = palette(length(pos0) + u_time);

        d =sin(d*8. + u_time)/8.;
        d = abs(d);

        d = .02/d;

        fcol += coul*d;


    }



    fragColor = vec4(fcol, 1.);

}