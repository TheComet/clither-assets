#version 330
precision mediump float;

attribute vec2 vPosition;
attribute vec2 vTexCoord;

// x,y contain factors for how much to "stretch" the x or y dimension
// For example, if the screen is 1920x1080 then x=16/9 and y=1
// z,w contain padding offsets. For example, if the screen is 1920x1080
// then z=16/9/2 and w=0
uniform vec2 uAspectRatio;
// Sprite position in camera space. Z component contains the camera's scale (1/zoom factor)
uniform vec2 uPosCameraSpace;
// Sprite size in camera space
uniform float uSize;

varying vec2 fTexCoord;

void main()
{
    fTexCoord = vTexCoord;

    vec2 pos = vPosition * uSize + uPosCameraSpace;
    pos = pos / uAspectRatio;

    gl_Position = vec4(pos, 0.0, 1.0);
}
