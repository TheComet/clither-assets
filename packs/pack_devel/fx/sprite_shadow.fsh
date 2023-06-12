precision mediump float;

varying vec2 fTexCoord;

uniform sampler2D sNM[4];

void main()
{
    float mask = texture2D(sNM[0], fTexCoord).a;
    gl_FragColor = vec4(vec3(1.0, 1.0, 1.0), mask);
}
