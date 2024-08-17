shader_type canvas_item;

uniform sampler2D outline_noise_tex;
uniform vec4 outline_color : source_color;
uniform float scissor_value = 0.5;
uniform vec2 uv_scale = vec2(1.0);
uniform sampler2D falloff_curve;
uniform float outline_size = 0.1;
uniform float offset_fres = 0.3;
uniform float fps = 5.0;

void fragment() {
    vec2 uv = FRAGCOORD.xy / SCREEN_PIXEL_SIZE.xy;
    
    // Calculate the Fresnel effect (pseudo for 2D)
    float fres = abs(dot(normalize(uv), vec2(0.0, 1.0)));
    
    // Generate some noise based on UV and time for animation
    float angle = atan(uv.y, uv.x);
    angle /= 3.14;
    
    float fres_remap = texture(falloff_curve, vec2(1.0 - fres, 0.0)).r + offset_fres;
    
    // Sample the noise texture
    float noise_value = texture(outline_noise_tex, vec2(angle * uv_scale.x + uv.x, uv.y * uv_scale.y + floor(TIME * fps) / fps)).r;
    
    // Compute the final alpha based on the noise and Fresnel remap
    float final_alpha = noise_value * fres_remap;
    
    // Set the color and alpha
    COLOR.rgb = outline_color.rgb;
    COLOR.a = final_alpha;
    
    // Apply scissor (clipping) based on the uniform value
    if (COLOR.a < scissor_value) {
        discard;
    }
}
