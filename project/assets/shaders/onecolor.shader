shader_type canvas_item;

uniform vec4 u_replacement_color : hint_color;

void fragment() {
    vec4 col = texture(TEXTURE, UV);
	float alpha = col.a;
    col = u_replacement_color;
	col.a = alpha;
    COLOR = col;
}