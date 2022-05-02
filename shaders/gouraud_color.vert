#version 300 es

precision highp float;

in vec3 vertex_position;
in vec3 vertex_normal;

uniform vec3 light_ambient;
uniform vec3 light_position;
uniform vec3 light_color;
uniform vec3 camera_position;
uniform int material_shininess; // n
uniform mat4 model_matrix;
uniform mat4 view_matrix;
uniform mat4 projection_matrix;

out vec3 ambient;
out vec3 diffuse;
out vec3 specular;

void main(){
    gl_Position = projection_matrix * view_matrix * model_matrix * vec4(vertex_position, 1.0);
    
    //normalized diretions and normals
    vec3 N = normalize(vertex_normal);
    vec3 L = normalize(light_position - vec3(model_matrix * vec4(vertex_position, 1.0)));
    vec3 R = normalize(vec3(2, 2, 2) * (N * L) * N - L);
    vec3 V = normalize(vec3(view_matrix * vec4(camera_position, 1)));

    ambient = light_ambient;
    diffuse = light_color * N * L;

    specular = light_color;
    for (int i=0; i < material_shininess; i++)
    {
        specular = specular * (R * V);
    }
}
