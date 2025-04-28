precision mediump float;

varying vec2 fTexCoord;
uniform sampler2D sCol;

vec3 uTint = vec3(1.0, 0.8, 0.4);

void main()
{
    vec4 tex = texture2D(sCol, fTexCoord);
    float outline = tex.r;
    float fill = tex.g;

    vec3 color = uTint * fill + uTint * 2.5 * outline;

    gl_FragColor = vec4(color, tex.a);
}
