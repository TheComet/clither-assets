precision mediump float;

attribute vec2 vPosition;
attribute vec2 vTexCoord;

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
varying vec3 fLightDir_tangentSpace;

void main()
{
	// Calculate UV coordinate for current frame of animation
    fTexCoord = vTexCoord * uAnim.xy + uAnim.zw;
	
	// Rotate, scale, and position the sprite. If the window is stretched,
	// we account for this by stretching the sprite in the opposite direction
    vec2 pos = mat2(uDir.x, uDir.y, uDir.y, -uDir.x) * vPosition;
    pos = pos * uSize * uPosCameraSpace.z + uPosCameraSpace.xy;
    pos = pos / uAspectRatio;

	// Light is currently slightly above camera's position and 1 unit above the sprites
	// Transform light from camera space into tangent space
    vec2 lightDir_cameraSpace = vec2(pos.x, pos.y - 0.5);
    fLightDir_tangentSpace = vec3(mat2(uDir.x, uDir.y, uDir.y, -uDir.x) * lightDir_cameraSpace, -1.0);

    gl_Position = vec4(pos, 0.0, 1.0);
}
