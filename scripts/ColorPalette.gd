extends Panel
class_name ColorPalette

var colors:PoolColorArray setget set_colors
const default_palette = "00000044243430346d4e4a4e854c30346524d04648757161597dced27d2c8595a16daa2cd2aa996dc2cadad45edeeed6"
var color_unit = preload("res://scenes/ColorPalette/ColorUnit.tscn")
signal color_selected

func set_colors(c: PoolColorArray):
	colors = c
	var col = $GridContainer.columns
	var row = ceil(1.0 * c.size() / col)
	rect_size.x = 32 * col + (col + 1) * 4
	rect_size.y = 32 * row + (row + 1) * 4
	
	for child in $GridContainer.get_children():
		$GridContainer.remove_child(child)
	for color in c:
		var node = color_unit.instance()
		node.color = color
		$GridContainer.add_child(node)
		node.connect("color_selected", self, "_on_color_selected")
		
func set_colors_s(s:String):
	set_colors(get_colors_from_String(s))

static func get_colors_from_String(palette:String) -> PoolColorArray:
	var result = PoolColorArray()
	result.append(Color.transparent)
	assert(palette.length() % 6 == 0)
	for i in range(0, palette.length(), 6):
		result.append(Color(palette.substr(i, 6)))
	return result

func _ready():
	set_colors(get_colors_from_String(default_palette))

func _on_color_selected(node:ColorRect):
	$ColorFrame.rect_position = node.rect_position
	$ColorFrame.rect_position += Vector2(4, 4)
	emit_signal("color_selected", node.color)
