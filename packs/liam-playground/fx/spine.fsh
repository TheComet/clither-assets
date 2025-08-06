#version 330
precision mediump float;

uniform sampler2D sTex0;
uniform sampler2D sTex1;

// x=U scale, y=U offset
uniform vec2 uScrollScaleOffset;
uniform float uCutoff;

varying vec2 fTexCoord;

void main()
{
    if (fTexCoord.x > uCutoff)
        discard;

    vec4 col = texture2D(sTex0, fTexCoord);
    vec4 nm = texture2D(sTex1, fTexCoord);
    gl_FragColor = vec4(col.rgb, nm.a);
}
