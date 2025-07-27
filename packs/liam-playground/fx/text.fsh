precision mediump float;

uniform sampler2D sAtlas;
varying vec2 fTexCoord;

void main()
{
    float color = texture2D(sAtlas, fTexCoord).a;
    gl_FragColor = vec4(1.0, 1.0, 1.0, color * 0.6);
}
