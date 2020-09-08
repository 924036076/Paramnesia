shader_type canvas_item;
render_mode unshaded;

uniform bool Smooth = false;
uniform float line_thickness : hint_range(0.0, 16) = 0;
uniform vec4 outline_color : hint_color = vec4(1.0, 1.0, 1.0, 1.0);
uniform int pixel_size : hint_range(0, 10) = 1;
 
void fragment()
{
	vec2 unit = (1.0/float(pixel_size) ) / vec2(textureSize(TEXTURE, 0));
	vec4 pixel_color = texture(TEXTURE, UV);
	if (pixel_color.a == 0.0) {
		pixel_color = outline_color;
		pixel_color.a = 0.0;
		for (float x = -ceil(line_thickness); x <= ceil(line_thickness); x++) {
			for (float y = -ceil(line_thickness); y <= ceil(line_thickness); y++) {
				if (texture(TEXTURE, UV + vec2(x*unit.x, y*unit.y)).a == 0.0 || (x==0.0 && y==0.0)) {
					continue;
				}
				if (Smooth) {
					pixel_color.a += outline_color.a / (pow(x,2)+pow(y,2)) * (1.0-pow(2.0, -line_thickness));
					if (pixel_color.a > 1.0) {
						pixel_color.a = 1.0;
					}
				} else {
					pixel_color.a = outline_color.a;
					return
				}
			}
		}
	}
	COLOR = pixel_color;
}