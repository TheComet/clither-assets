precision mediump float;

attribute vec2 vPosition;
attribute vec2 vTexCoord;

uniform vec2 uAspectRatio;
uniform vec3 uPosCameraSpace;
uniform vec2 uDir;
uniform float uSize;
uniform vec4 uAnim;

varying vec2 fTexCoord;
varying vec3 fLightDir_tangentSpace;

void main()
{
    fTexCoord = vTexCoord * uAnim.xy + uAnim.zw;
    vec2 pos = mat2(uDir.x, uDir.y, uDir.y, -uDir.x) * vPosition;
    pos = pos * uSize * uPosCameraSpace.z + uPosCameraSpace.xy;
    pos = pos / uAspectRatio;

    vec2 lightDir_cameraSpace = vec2(pos.x, pos.y - 0.5);
    fLightDir_tangentSpace = vec3(mat2(uDir.x, uDir.y, uDir.y, -uDir.x) * lightDir_cameraSpace, -1.0);

    gl_Position = vec4(pos, 0.0, 1.0);
}
