precision mediump float;

attribute vec2 vPosition;

varying vec2 fTexCoord;
varying vec3 fLightDir;

void main()
{
    // To make the math a bit simpler, we use UV coordinates from [-0.5, 0.5]
    // instead of [0, 1]. This centers the camera at [0, 0] and it's easier to
    // apply zoom and aspect ratio adjustments.
    fTexCoord = vPosition * 0.5;
	
	// Light is currently slightly above camera's position and 1 unit above the sprites
    vec3 lightPos = vec3(vPosition.x, vPosition.y + 0.5, 3.0);
    vec3 vPos = vec3(vPosition, 0.0);
    fLightDir = normalize(vPos - lightPos);
    gl_Position = vec4(vPosition, 0.0, 1.0);
}
