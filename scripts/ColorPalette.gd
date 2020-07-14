extends Panel
class_name ColorPalette

var colors:PoolColorArray setget set_colors
var color_unit = preload("res://scenes/ColorPalette/ColorUnit.tscn")
var cur_node
signal color_selected

onready var gcontainer = $VBoxContainer/Container/GridContainer
onready var eraser = $VBoxContainer/Container/GridContainer/ColorUnit

func _ready():
	eraser.connect("color_selected", self, "_on_color_selected")
	set_colors_s(Globals.DEFAULT_PALETTE)

func set_colors(c: PoolColorArray):
	colors = c
	for child in gcontainer.get_children():
		if child == eraser: continue
		gcontainer.remove_child(child)
	for color in c:
		var node = color_unit.instance()
		node.color = color
		gcontainer.add_child(node)
		node.connect("color_selected", self, "_on_color_selected")
	cur_node = eraser
	cur_node.set_frame_vis(true)

func set_colors_s(s:String):
	set_colors(get_colors_from_String(s))

static func get_colors_from_String(palette:String) -> PoolColorArray:
	var result = PoolColorArray()
	assert(palette.length() % 6 == 0)
	for i in range(0, palette.length(), 6):
		result.append(Color(palette.substr(i, 6)))
	return result

func _on_color_selected(node:ColorRect):
	if node == cur_node: return
	cur_node.set_frame_vis(false)
	cur_node = node
	cur_node.set_frame_vis(true)
	emit_signal("color_selected", node.color)
