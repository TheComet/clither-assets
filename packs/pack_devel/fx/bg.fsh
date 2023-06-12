precision mediump float;
#define TILE_SCALE 0.5

// x,y contain factors for how much to "stretch" the x or y dimension
// For example, if the screen is 1920x1080 then x=16/9 and y=1
// z,w contain padding offsets. For example, if the screen is 1920x1080
// then z=16/9/2 and w=0
uniform vec4 uAspectRatio;

// x,y = camera's location in world space, z = scale = 1/zoom
uniform vec3 uCamera;

// Inverse resolution of the shadow texture, for example if the
// shadow texture is 480x270, then x,y = 1/480,1/270
uniform vec2 uShadowInvRes;

// Contains the shadow mask (white = shadow, black = no shadow)
// It spans the entire screen and aspect ratio adjustments have
// already been made
uniform sampler2D sShadow;

// Color and normal map
uniform sampler2D sCol;
uniform sampler2D sNM;

varying vec2 fTexCoord;
varying vec3 fLightDir;

void main()
{
	// The background texture is rendered to a fullscreen quad. We can
	// create the illusion of a moving background by scrolling the texture's UV
	// coordinates depending on camera position
    vec2 uv = (fTexCoord - 0.5) / uCamera.z * uAspectRatio.xy + uCamera.xy / 2.0;
    uv = uv * TILE_SCALE;
	
	// Sample both textures
    vec3 color = dot(uv, uv) < 8.0 ? texture2D(sCol, uv).rgb : vec3(0.2, 0.2, 0.2);  // world border
    vec3 nm = texture2D(sNM, uv).rgb;

    // Reconstruct the normal map Z dimension using the relationship x^2 + y^2 + z^2 = 1
    vec3 normal;
    normal.xy = nm.xy * 2.0 - 1.0;
    normal.z = sqrt(1.0 - dot(normal.xy, normal.xy));

	// Normal influence
    vec3 lightDir = normalize(fLightDir);
    float normFac = clamp(dot(normal, -lightDir), 0.0, 1.0);
    color = color * (1.0-0.9) + normFac * color * 0.9;

    // Apply a 5x5 Gaussian blur filter for smoother shadows
    float shadowFac = 
        1.0  * texture2D(sShadow, vec2(fTexCoord.x-2.0*uShadowInvRes.x, fTexCoord.y-2.0*uShadowInvRes.y)).r +
        4.0  * texture2D(sShadow, vec2(fTexCoord.x-1.0*uShadowInvRes.x, fTexCoord.y-2.0*uShadowInvRes.y)).r +
        7.0  * texture2D(sShadow, vec2(fTexCoord.x+0.0*uShadowInvRes.x, fTexCoord.y-2.0*uShadowInvRes.y)).r +
        4.0  * texture2D(sShadow, vec2(fTexCoord.x+1.0*uShadowInvRes.x, fTexCoord.y-2.0*uShadowInvRes.y)).r +
        1.0  * texture2D(sShadow, vec2(fTexCoord.x+2.0*uShadowInvRes.x, fTexCoord.y-2.0*uShadowInvRes.y)).r +

        4.0  * texture2D(sShadow, vec2(fTexCoord.x-2.0*uShadowInvRes.x, fTexCoord.y-1.0*uShadowInvRes.y)).r +
        16.0 * texture2D(sShadow, vec2(fTexCoord.x-1.0*uShadowInvRes.x, fTexCoord.y-1.0*uShadowInvRes.y)).r +
        26.0 * texture2D(sShadow, vec2(fTexCoord.x+0.0*uShadowInvRes.x, fTexCoord.y-1.0*uShadowInvRes.y)).r +
        16.0 * texture2D(sShadow, vec2(fTexCoord.x+1.0*uShadowInvRes.x, fTexCoord.y-1.0*uShadowInvRes.y)).r +
        4.0  * texture2D(sShadow, vec2(fTexCoord.x+2.0*uShadowInvRes.x, fTexCoord.y-1.0*uShadowInvRes.y)).r +

        7.0  * texture2D(sShadow, vec2(fTexCoord.x-2.0*uShadowInvRes.x, fTexCoord.y+0.0*uShadowInvRes.y)).r +
        26.0 * texture2D(sShadow, vec2(fTexCoord.x-1.0*uShadowInvRes.x, fTexCoord.y+0.0*uShadowInvRes.y)).r +
        41.0 * texture2D(sShadow, vec2(fTexCoord.x+0.0*uShadowInvRes.x, fTexCoord.y+0.0*uShadowInvRes.y)).r +
        26.0 * texture2D(sShadow, vec2(fTexCoord.x+1.0*uShadowInvRes.x, fTexCoord.y+0.0*uShadowInvRes.y)).r +
        7.0  * texture2D(sShadow, vec2(fTexCoord.x+2.0*uShadowInvRes.x, fTexCoord.y+0.0*uShadowInvRes.y)).r +

        4.0  * texture2D(sShadow, vec2(fTexCoord.x-2.0*uShadowInvRes.x, fTexCoord.y+1.0*uShadowInvRes.y)).r +
        16.0 * texture2D(sShadow, vec2(fTexCoord.x-1.0*uShadowInvRes.x, fTexCoord.y+1.0*uShadowInvRes.y)).r +
        26.0 * texture2D(sShadow, vec2(fTexCoord.x+0.0*uShadowInvRes.x, fTexCoord.y+1.0*uShadowInvRes.y)).r +
        16.0 * texture2D(sShadow, vec2(fTexCoord.x+1.0*uShadowInvRes.x, fTexCoord.y+1.0*uShadowInvRes.y)).r +
        4.0  * texture2D(sShadow, vec2(fTexCoord.x+2.0*uShadowInvRes.x, fTexCoord.y+1.0*uShadowInvRes.y)).r +

        1.0  * texture2D(sShadow, vec2(fTexCoord.x-2.0*uShadowInvRes.x, fTexCoord.y+2.0*uShadowInvRes.y)).r +
        4.0  * texture2D(sShadow, vec2(fTexCoord.x-1.0*uShadowInvRes.x, fTexCoord.y+2.0*uShadowInvRes.y)).r +
        7.0  * texture2D(sShadow, vec2(fTexCoord.x+0.0*uShadowInvRes.x, fTexCoord.y+2.0*uShadowInvRes.y)).r +
        4.0  * texture2D(sShadow, vec2(fTexCoord.x+1.0*uShadowInvRes.x, fTexCoord.y+2.0*uShadowInvRes.y)).r +
        1.0  * texture2D(sShadow, vec2(fTexCoord.x+2.0*uShadowInvRes.x, fTexCoord.y+2.0*uShadowInvRes.y)).r;
    shadowFac /= 273.0;

	// Apply shadow
    shadowFac = (1.0 - shadowFac) * 0.9 + 0.1;
	color *= shadowFac;

    gl_FragColor = vec4(color, 1.0);
}
