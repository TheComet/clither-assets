precision mediump float;

// NOTE: Must be the same value as in spine.c
#define QUADS 8

attribute vec2 vPosition;

// Bezier coefficients in local space of the bezier curve
uniform vec2 uCoeff[3];
// Width and length of the bezier strip in camera space
uniform vec2 uBezierSize;
// Coordinate of where the bezier curve begins in camera space
uniform vec2 uHeadPosition;
// Screen aspect ratio (xy) and camera zoom factor (z)
uniform vec3 uAspectRatio;
// x=U scale, y=U offset
uniform vec2 uScrollScaleOffset;

varying vec2 fTexCoord;

vec2 sample_bezier(float t)
{
    return uCoeff[0] * t + uCoeff[1] * t * t + uCoeff[2] * t * t * t;
}

vec2 sample_bezier_derivative(float t)
{
    return uCoeff[0] + 2.0 * uCoeff[1] * t + 3.0 * uCoeff[2] * t * t;
}

float calculate_u_coord(float t)
{
    vec2 last = vec2(0.0, 0.0);
    float u_coord = 0.0;
    for (int i = 1; i <= QUADS; ++i) {
        if (float(i) > t * float(QUADS)) {
            break;
        }
        float t0 = float(i) / float(QUADS);
        vec2 sample = sample_bezier(t0);
        u_coord += length(sample - last);
        last = sample;
    }

    return u_coord / uBezierSize.y;
}

void main()
{
    float t = vPosition.x;

    fTexCoord = vec2(
        calculate_u_coord(t) * uScrollScaleOffset.x + uScrollScaleOffset.y,
        vPosition.y * 0.5 + 0.5);

    vec2 sample = sample_bezier(t);
    vec2 tangent = normalize(sample_bezier_derivative(t));
    vec2 normal = vec2(-tangent.y, tangent.x);
    vec2 pos = uHeadPosition + sample + vPosition.y * normal * uBezierSize.x;
    pos = pos * uAspectRatio.z / uAspectRatio.xy;

    gl_Position = vec4(pos, 0.0, 1.0);
}
