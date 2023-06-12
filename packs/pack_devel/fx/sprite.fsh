precision mediump float;

varying vec2 fTexCoord;
varying vec3 fLightDir_tangentSpace;

uniform sampler2D sDiffuse;
uniform sampler2D sNM;

vec3 uTint = vec3(1.0, 0.8, 0.4);

void main()
{
    vec4 col = texture2D(sDiffuse, fTexCoord);
    vec4 nm = texture2D(sNM, fTexCoord);
    float mask = col.a * 0.4;
    vec3 color = col.rgb;

    color = color * (1.0-mask) + uTint * mask;

    vec3 normal;
    normal.xy = nm.xy * 2.0 - 1.0;
    normal.z = sqrt(1.0 - dot(normal.xy, normal.xy));

    vec3 lightDir = normalize(fLightDir_tangentSpace);
    float normFac = clamp(dot(normal, -lightDir), 0.0, 1.0);
    color = color * (1.0 - 0.9) + color * normFac * 0.9;

    gl_FragColor = vec4(color, nm.a);
}
