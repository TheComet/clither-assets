precision mediump float;

uniform sampler2D sTex0;
uniform sampler2D sTex1;
uniform vec2 uScroll;

varying vec2 fTexCoord;

void main()
{
    vec2 uv = vec2(fTexCoord.x * uScroll.y + uScroll.x, fTexCoord.y);
    vec4 col = texture2D(sTex0, uv);
    vec4 nm = texture2D(sTex1, uv);
    gl_FragColor = vec4(col.rgb, nm.a);
}
