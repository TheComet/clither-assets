precision mediump float;

varying vec2 fTexCoord;
varying vec3 fLightDir;

uniform sampler2D sTex0;
uniform sampler2D sTex1;

uniform vec2 uDir;

vec3 uTint = vec3(1.0, 0.8, 0.4);

void main()
{
	// Sample textures
    vec4 col = texture2D(sTex0, fTexCoord);
    vec4 nm = texture2D(sTex1, fTexCoord);
    float tintMask = col.a * 0.4;
    vec3 color = col.rgb;

	// Apply user color (tint)
    color = color * (1.0-tintMask) + uTint * tintMask;

    // Reconstruct the normal map Z dimension using the relationship x^2 + y^2 + z^2 = 1
    vec3 normal;
    normal.xy = nm.xy * 2.0 - 1.0;
    normal.z = sqrt(1.0 - dot(normal.xy, normal.xy));

    mat3 rotate = mat3(
        -uDir.x, uDir.y, 0.0,
        uDir.y, uDir.x, 0.0,
        0.0, 0.0, 1.0);
    //normal = rotate * normal;

	// Normal influence
    vec3 lightDir = normalize(fLightDir);
    float normFac = clamp(dot(normal, -lightDir), 0.0, 1.0);
    color = color * (1.0 - 0.9) + color * normFac * 0.9;

    //gl_FragColor = vec4(color, nm.a);
    gl_FragColor = vec4(color, nm.a);
}
