shader_type canvas_item;

uniform float pixel_size=0.004;
uniform float pixel_ratio=0.5625;
uniform vec4 tint : hint_color;
uniform float mixin = 0.4;

void fragment() {
	vec2 uv = SCREEN_UV;
  float pixel_y = pixel_size;// * 1.777778;
  float pixel_x = pixel_size * pixel_ratio;
	uv-=mod(uv,vec2(pixel_x, pixel_y));
	
	COLOR.rgb= mix(textureLod(SCREEN_TEXTURE,uv,0.0).rgb, tint.rgb, mixin);
}