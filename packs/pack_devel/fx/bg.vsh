attribute vec2 vPosition;
attribute vec2 vTexCoord;

varying vec2 fTexCoord;
varying vec3 fLightDir;

void main()
{
    fTexCoord = vTexCoord;
    fLightDir = vec3(vec2(vPosition.x, vPosition.y - 0.5), -1.0);
    gl_Position = vec4(vPosition, 0.0, 1.0);
}
