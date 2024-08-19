shader_type canvas_item;

uniform float SAMPLES = 10.0;
uniform sampler2D SCREEN_TEXTURE : hint_screen_texture;
const float WIDTH = 0.04734573810584494679397346954847;

uniform vec2 blur = vec2(0, 0);

float gaussian(float x) {
    float x_squared = x * x;
    return WIDTH * exp((x_squared / (2.0 * SAMPLES)) * -1.0);
}

void fragment() {
	vec2 scale = TEXTURE_PIXEL_SIZE * blur * 0.001;
	float weight = 0.0;
	float total_weight = 0.0;
	vec4 color = vec4(0.0);

	for(int i = -int(SAMPLES) / 2; i < int(SAMPLES) / 2; i++) {
		weight = gaussian(float(i));
		color.rgb += texture(SCREEN_TEXTURE, SCREEN_UV + scale * vec2(float(i))).rgb * weight;
		total_weight += weight;
	}
	COLOR.rgb = color.rgb / total_weight;
}