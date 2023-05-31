#version 330

layout (location = 0) in vec3 vPos;
layout (location = 1) in vec2 textcoord;


out vec2 v_textcoord;

//uniform float weight;
uniform mat4 model, view, proj;


void main(void) {
    gl_Position = proj*view*model*vec4(vPos, 1.1);

    v_textcoord = textcoord;
}