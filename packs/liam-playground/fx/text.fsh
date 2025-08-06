precision mediump float;

uniform sampler2D sAtlas;
uniform vec4 uColor;

varying vec2 fTexCoord;

void main()
{
    float alpha = texture2D(sAtlas, fTexCoord).a;
    gl_FragColor = vec4(uColor.rgb, uColor.a * alpha);
}
