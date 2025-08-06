precision mediump float;

attribute vec2 vPosition;

// x,y contain factors for how much to "stretch" the x or y dimension
// For example, if the screen is 1920x1080 then x=16/9 and y=1
// z,w contain padding offsets. For example, if the screen is 1920x1080
// then z=16/9/2 and w=0
uniform vec2 uAspectRatio;
// Sprite position in camera space. Z component contains the camera's scale (1/zoom factor)
uniform vec3 uPosCameraSpace;
// Sprite direction vector in camera space
uniform vec2 uDir;
// Sprite size in camera space
uniform float uSize;
// UV coordinates to extract the current frame of animation from the sprite sheet
uniform vec4 uAnim;

varying vec2 fTexCoord;
varying vec3 fLightDir;

void main()
{
	// Calculate UV coordinate for current frame of animation
    fTexCoord = vPosition * 0.5 + 0.5;
    fTexCoord = fTexCoord * uAnim.xy + uAnim.zw;
	
	// Rotate, scale, and position the sprite. If the window is stretched,
	// we account for this by stretching the sprite in the opposite direction
    vec2 pos = mat2(uDir.x, uDir.y, uDir.y, -uDir.x) * vPosition;
    pos = pos * uSize * uPosCameraSpace.z + uPosCameraSpace.xy;
    pos = pos / uAspectRatio;

	// Light is currently slightly above camera's position and 1 unit above the sprites
	// Transform light from camera space into tangent space
    vec3 lightPos = vec3(pos.x, pos.y + 0.5, 3.0);
    vec3 spritePos = vec3(pos, 0.0);
    vec3 lightDir = normalize(spritePos - lightPos);
    mat3 rotate = mat3(
        -uDir.x, uDir.y, 0.0,
        uDir.y, uDir.x, 0.0,
        0.0, 0.0, 1.0);
    fLightDir = rotate * lightDir;

    gl_Position = vec4(pos, 0.0, 1.0);
}
