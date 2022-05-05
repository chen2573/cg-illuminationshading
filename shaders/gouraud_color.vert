#version 300 es

precision highp float;

in vec3 vertex_position;
in vec3 vertex_normal;

uniform vec3 light_ambient;
uniform vec3 light_position[10];
uniform vec3 light_color[10];
uniform vec3 camera_position;
uniform float material_shininess; // n
uniform mat4 model_matrix;
uniform mat4 view_matrix;
uniform mat4 projection_matrix;

out vec3 ambient;
out vec3 diffuse;
out vec3 specular;

void main(){
    gl_Position = projection_matrix * view_matrix * model_matrix * vec4(vertex_position, 1.0);

    //initialize out vecs
    ambient = light_ambient;
    diffuse = vec3(0.0, 0.0, 0.0);
    specular = vec3(0.0, 0.0, 0.0);

    //loop through lights
    for (int i=0; i<10; i++)
    {    
        //normalized diretions and normals
        vec3 N = normalize(vec3(transpose(inverse(model_matrix)) * vec4(vertex_normal, 1.0)));
        vec3 L = normalize(light_position[i] - vec3(model_matrix * vec4(vertex_position, 1.0)));
        float NDotL = dot(N, L);
        if (NDotL < 0.0) {NDotL = 0.0;} //cap the dot product at 0

        vec3 R = normalize(vec3(2, 2, 2) * NDotL * N - L);
        vec3 V = normalize(camera_position - vec3(model_matrix * vec4(vertex_position, 1.0)));
        float RDotV = dot(R, V);
        if (RDotV < 0.0) {RDotV = 0.0;} //cap the dot product at 0

        //update lights
        diffuse = diffuse + light_color[i] * NDotL;
        specular = specular + light_color[i] * pow(RDotV, material_shininess);
    }
}
