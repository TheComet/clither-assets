precision mediump float;

attribute vec2 vPosition;

uniform float uWidth;
uniform vec2 uCoeff[3];
uniform vec2 uHeadPosition;
uniform vec3 uAspectRatio;

varying vec2 fTexCoord;

void main()
{
    float t = vPosition.x;
    vec2 sample =  uCoeff[0] * t + uCoeff[1] * t * t + uCoeff[2] * t * t * t;
    vec2 tangent = normalize(uCoeff[0] + 2.0 * uCoeff[1] * t + 3.0 * uCoeff[2] * t * t);
    vec2 normal = vec2(-tangent.y, tangent.x);
    vec2 pos = uHeadPosition + sample + vPosition.y * normal * uWidth;
    pos = pos * uAspectRatio.z / uAspectRatio.xy;

    fTexCoord = vec2(vPosition.x, vPosition.y * 0.5 + 0.5);
    gl_Position = vec4(pos, 0.0, 1.0);
}
