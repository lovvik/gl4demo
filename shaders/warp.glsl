#version 330

precision highp float;

out vec4 fragColor ;

uniform vec2 u_resolution;
uniform float u_time;


mat2 rotate2d(in float radians){
    float c = cos(radians);
    float s = sin(radians);
    return mat2(c, -s, s, c);
}


vec2 warp (vec2 p) {
	float t = u_time*.001;
    //t = .3*sin(u_time+cos(u_time));
	float r = length(p);
    //r = dot(p, vec2(1.));
	float alpha = t * r;
	return rotate2d(alpha) * p;
}



float sdCircle( vec2 p, float r )
{
    return length(p) - r;
}

float grid( in vec2 pos, float n){
    return step(.98,fract(pos.x*n)) + step(.98,fract(pos.y*n));
}


void main(){
    vec2 pos = (2.0 * gl_FragCoord.xy - u_resolution) / min(u_resolution.x, u_resolution.y);
    vec3 color=  vec3(.0);


    pos*=7.;
    



    pos = warp(pos);
    vec3 blkhole = vec3(sdCircle(pos, .6));

    color = vec3(grid(pos, 3.))*vec3(0.6, .1, .8);
    color = mix(vec3(.0), color,blkhole );




    
    

    fragColor = vec4(color, 1.);

}