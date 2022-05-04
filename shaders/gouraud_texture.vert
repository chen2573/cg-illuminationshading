#version 300 es

precision highp float;

in vec3 vertex_position;
in vec3 vertex_normal;
in vec2 vertex_texcoord;

uniform vec3 light_ambient;
uniform vec3 light_position;
uniform vec3 light_color;
uniform vec3 camera_position;
uniform float material_shininess;
uniform vec2 texture_scale;
uniform mat4 model_matrix;
uniform mat4 view_matrix;
uniform mat4 projection_matrix;

out vec3 ambient;
out vec3 diffuse;
out vec3 specular;
out vec2 frag_texcoord;

void main() {
    gl_Position = projection_matrix * view_matrix * model_matrix * vec4(vertex_position, 1.0);

    //lighting
    vec3 N = normalize(vertex_normal);
    vec3 L = normalize(light_position - vec3(model_matrix * vec4(vertex_position, 1.0)));
    float NDotL = dot(N, L);
    if (NDotL < 0.0) {NDotL = 0.0;} //cap the dot product at 0

    vec3 R = normalize(vec3(2, 2, 2) * NDotL * N - L);
    vec3 V = normalize(camera_position - vec3(model_matrix * vec4(vertex_position, 1.0)));
    float RDotV = dot(R, V);
    if (RDotV < 0.0) {RDotV = 0.0;} //cap the dot product at 0

    ambient = light_ambient;
    diffuse = light_color * NDotL;
    specular = light_color * pow(RDotV, material_shininess);

    //texture
    frag_texcoord = vertex_texcoord * texture_scale;
}
