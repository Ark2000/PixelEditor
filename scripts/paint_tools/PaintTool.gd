class_name PaintTool

var canvas setget set_canvas #画布
var helper_layer setget set_helper_layer	#提示层
var color setget set_color #画笔颜色

func paint_tool_update(_mpos: Vector2):
	assert(false)

func set_canvas(canvas_):
	canvas = canvas_
	
func set_color(color_):
	color = color_

func set_helper_layer(layer):
	helper_layer = layer