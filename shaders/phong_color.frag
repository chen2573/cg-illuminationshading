#version 300 es

precision mediump float;

in vec3 frag_pos;
in vec3 frag_normal;

uniform vec3 light_ambient;
uniform vec3 light_position;
uniform vec3 light_color;
uniform vec3 camera_position;
uniform vec3 material_color;      // Ka and Kd
uniform vec3 material_specular;   // Ks
uniform float material_shininess; // n

out vec4 FragColor;

void main() {

    //normalized diretions and normals
    vec3 N = normalize(frag_normal);
    vec3 L = normalize(light_position - frag_pos);
    float NDotL = dot(N, L);
    if (NDotL < 0.0) {NDotL = 0.0;} //cap the dot product at 0

    vec3 R = normalize(vec3(2, 2, 2) * NDotL * N - L);
    vec3 V = normalize(camera_position - frag_pos);
    float RDotV = dot(R, V);
    if (RDotV < 0.0) {RDotV = 0.0;} //cap the dot product at 0
    
    vec3 light_diffuse = light_color * NDotL;
    vec3 light_specular = light_color * pow(RDotV, material_shininess);
    
    FragColor = vec4((light_ambient * material_color) + (light_diffuse * material_color) + light_specular, 1.0);
}

    

