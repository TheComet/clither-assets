// Need highp in this case because uv coordinates are world
// coordinates
precision highp float;

#define TILE_SCALE 2.0

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

// Squared world border, x = inner radius, y = ring start, z = ring end
uniform vec3 uWorldBorder;

// Contains the shadow mask (white = shadow, black = no shadow)
// It spans the entire screen and aspect ratio adjustments have
// already been made
uniform sampler2D sShadow;

uniform sampler2D sCol;

varying vec2 fTexCoord;

void main()
{
    // The background texture is rendered to a fullscreen quad. We can
    // create the illusion of a moving background by scrolling the texture's UV
    // coordinates depending on camera position
    //
    // To make the math a bit simpler, we use UV coordinates from [-0.5, 0.5]
    // instead of [0, 1]. This centers the camera at [0, 0] and it's easier to
    // apply zoom and aspect ratio adjustments.

    // World space [-1, 1] -> UV space [-0.5, 0.5]
    vec2 cameraPos_uvSpace = uCamera.xy / 2.0;
    vec3 worldBorder_uvSpace = uWorldBorder / 2.0;

    // Calculate texcoord position in UV space
    float a = 0.05;
    vec2 texCoord_uvSpace = fTexCoord / uCamera.z * uAspectRatio.xy;
    vec2 pos_uvSpace = texCoord_uvSpace + cameraPos_uvSpace;
    //pos_uvSpace = mat2(cos(a), -sin(a), sin(a), cos(a)) * pos_uvSpace;
    
    vec3 tex = texture2D(sCol, pos_uvSpace * TILE_SCALE).rgb;
    float outline = tex.r;
    float fill = tex.g;
    vec3 color = vec3(0.0, 0.8, 0.75) * outline
               + vec3(0.08, 0.04, 0.31) * fill;

    float innerRadiusSq = worldBorder_uvSpace.x * worldBorder_uvSpace.x;
    float ringStartSq = worldBorder_uvSpace.y * worldBorder_uvSpace.y;
    float ringEndSq = worldBorder_uvSpace.z * worldBorder_uvSpace.z;
    float distSq = dot(pos_uvSpace, pos_uvSpace);
    float mixBorder1 = clamp((distSq - innerRadiusSq) * 0.05, 0.0, 1.0);
    float mixBorder2 = clamp((distSq - ringStartSq) * 0.05, 0.0, 1.0);
    float mixBorder3 = clamp((distSq - ringEndSq) * 0.01, 0.0, 1.0);
    float mixBorder = mixBorder1 - mixBorder2 + mixBorder3;
    float fade = clamp(1.0 - (distSq - ringEndSq) * 0.005, 0.0, 1.0);
    color = vec3(0.2, 0.2, 0.2)*mixBorder + (1.0-mixBorder)*color;
    color *= fade;

    gl_FragColor = vec4(color, 1.0);
}
