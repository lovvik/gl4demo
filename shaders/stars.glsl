#version 330


/*uniform vec2 u_resolution;

out vec4 fragColor;

#version 300 es*/

precision mediump float;

#define RANDOM_SCALE vec4(.1031, .1030, .0973, .1099)

in vec2 uv;
out vec4 fragColor ;

uniform vec2 u_resolution;
uniform float u_time;
//uniform vec4 u_mouse;

float random(in vec2 st) {
    vec3 p3  = fract(vec3(st.xyx) * RANDOM_SCALE.xyz);
    p3 += dot(p3, p3.yzx + 33.33);
    return fract((p3.x + p3.y) * p3.z);
    //return fract(sin(dot(st.xy, vec2(12.9898, 78.233))) * 43758.5453);
}

float hash21(vec2 p){
    p = fract(p*vec2(123.34, 456.21));
    p+=dot(p , p+45.32);
    return fract(p.x*p.y);
}

float mycircle(vec2 centre, float size, in vec2 pos){
    return 1.-step(size, distance(pos, centre));
}

float myrand(in vec2 pos){
    float m = mix(-4., 4., random(pos));
    return m;
}

float star(vec2 centre, in vec2 pos){
    float m =  .15*(.06 * sin(u_time)+ .1) /length(pos - centre);
    return m * smoothstep(.5, .2, length(pos-centre));
    //     size
    //return 0.03 *(.02 * sin(u_time)+ .08) /length(pos - centre);
    
}



void tiles(inout vec2 pos, float n){
	pos*=n;
	pos = fract(pos);
}

vec3 palette( in float t)
{   
    vec3 a = vec3(0.448, 0.328 ,0.498);
    vec3 b = vec3(0.378, 0.481, 0.896);
    vec3 c = vec3(2.598, 0.340, 0.296);
    vec3 d = vec3(5.958, 6.164, 2.865);

    return a + b*cos( 6.28318*(c*t+d) );
}


vec3 star_layer(in vec2 pos){

    vec2 gv = fract(pos) - .5;
    vec2 id = floor(pos);
    

    vec3 color = vec3(.0);

    for (int y=-1; y<2; y++){
        for(int x=-1; x<2; x++){
            vec2 offs = vec2(x,y);
            float n = myrand(id+offs);
            float m = myrand((id+offs));

            float star =star(vec2(n,m)+offs, gv);
            // multiplication de star par une taille aleatoire et une couleur aléatoire
            color+=star*fract(n*34567.566)*palette(n*m*u_time/100.);
        }
    }

    return color;
}


void main(){
    vec2 pos = (2.0 * gl_FragCoord.xy - u_resolution) / min(u_resolution.x, u_resolution.y);
    //pos+=.5;

    //pos*=7.;


    vec3 color = vec3(.0);

    float n_layers = 3.;
    float t =u_time*.05;

    for (float i=0.; i<1.; i+=1./n_layers){
        float depth = fract(i+t);

        float skale = mix(20., .5, depth);

        float fade = depth;



        color += star_layer(pos*skale+i*453.56)* fade;
    }


    fragColor = vec4(color, 1.);

}