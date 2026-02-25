shader_type spatial;

uniform float speed = 1.0;
uniform float saturation = 1.0;
uniform float brightness = 1.0;

// Function to convert HSV to RGB
vec3 hsv2rgb(vec3 c) {
    vec4 K = vec4(1.0, 2.0 / 3.0, 1.0 / 3.0, 3.0);
    vec3 p = abs(fract(c.xxx + K.xyz) * 6.0 - K.www);
    return c.z * mix(K.xxx, clamp(p - K.xxx, 0.0, 1.0), c.y);
}

void fragment() {
    // Cycle hue over time
    float hue = fract(TIME * speed * 0.1);
    vec3 rainbow = hsv2rgb(vec3(hue, saturation, brightness));
    
    // Apply to albedo
    ALBEDO = rainbow;
    // Optional: Make it glow (Emission)
    EMISSION = rainbow * 0.5;
}
