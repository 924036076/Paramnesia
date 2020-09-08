shader_type canvas_item;

uniform vec4 highlight_color : hint_color;

void fragment()
{
	vec4 current_color = texture(TEXTURE, UV);
	
	if (current_color[3] != 0.0)
	{
		vec4 new_color = highlight_color;
		new_color[3] = 0.5;
		COLOR = new_color;
	} else {
		COLOR = current_color;
	}
}