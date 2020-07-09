extends ScrollContainer
class_name ColorPalette

var colors:PoolColorArray setget set_colors
const default_palette = "00000044243430346d4e4a4e854c30346524d04648757161597dced27d2c8595a16daa2cd2aa996dc2cadad45edeeed6"
var color_unit = preload("res://scenes/ColorPalette/ColorUnit.tscn")
signal color_selected

onready var gcontainer = $Panel/GridContainer
onready var cf = $Panel/ColorFrame

func set_colors(c: PoolColorArray):
	colors = c
	var col = gcontainer.columns
	var row = ceil(1.0 * c.size() / col)
	get_child(0).rect_min_size.x = 32 * col + (col + 1) * 4
	get_child(0).rect_min_size.y = 32 * row + (row + 1) * 4
	print()
	for child in gcontainer.get_children():
		gcontainer.remove_child(child)
	for color in c:
		var node = color_unit.instance()
		node.color = color
		gcontainer.add_child(node)
		node.connect("color_selected", self, "_on_color_selected")
		
func set_colors_s(s:String):
	set_colors(get_colors_from_String(s))
	cf.rect_position = gcontainer.rect_position

static func get_colors_from_String(palette:String) -> PoolColorArray:
	var result = PoolColorArray()
	result.append(Color.transparent)
	assert(palette.length() % 6 == 0)
	for i in range(0, palette.length(), 6):
		result.append(Color(palette.substr(i, 6)))
	return result

func _ready():
	set_colors(get_colors_from_String(default_palette))
	print(rect_size)

func _on_color_selected(node:ColorRect):
	cf.rect_position = node.rect_position
	cf.rect_position += Vector2(4, 4)
	emit_signal("color_selected", node.color)
