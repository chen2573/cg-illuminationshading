#version 300 es

precision mediump float;

in vec3 frag_pos;
in vec3 frag_normal;
in vec2 frag_texcoord;

uniform vec3 light_ambient;
uniform vec3 light_position;
uniform vec3 light_color;
uniform vec3 camera_position;
uniform vec3 material_color;      // Ka and Kd
uniform vec3 material_specular;   // Ks
uniform float material_shininess; // n
uniform sampler2D image;          // use in conjunction with Ka and Kd

out vec4 FragColor;

void main() {
    //initialize light vecs
    vec3 light_diffuse = vec3(0.0, 0.0, 0.0);
    vec3 light_specular = vec3(0.0, 0.0, 0.0);

    //loop through light sources
    for (int i=0; i<10; i++)
    {
        //normalized diretions and normals
        vec3 N = normalize(frag_normal);
        vec3 L = normalize(light_position[i] - frag_pos);
        float NDotL = dot(N, L);
        if (NDotL < 0.0) {NDotL = 0.0;} //cap the dot product at 0

        vec3 R = normalize(vec3(2, 2, 2) * NDotL * N - L);
        vec3 V = normalize(camera_position - frag_pos);
        float RDotV = dot(R, V);
        if (RDotV < 0.0) {RDotV = 0.0;} //cap the dot product at 0
        
        light_diffuse = light_diffuse + light_color[i] * NDotL;
        light_specular = light_specular + light_color[i] * pow(RDotV, material_shininess);
    }

    //texture
    FragColor = vec4(vec3(texture(image, frag_texcoord)) * ((light_ambient * material_color) + (light_diffuse * material_color) + light_specular * material_specular), 1.0);
}
