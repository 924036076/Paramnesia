shader_type canvas_item;

uniform bool highlight = true;

void fragment()
{
	vec4 current_color = texture(TEXTURE, UV);
	
	if (current_color[3] != 0.0 && highlight)
	{
		vec4 new_color = current_color;
		new_color[0] = 100.0;
		new_color[1] = new_color[1] / 3.0;
		new_color[2] = new_color[2] / 3.0;
		COLOR = new_color;
	} else {
		COLOR = current_color;
	}
}