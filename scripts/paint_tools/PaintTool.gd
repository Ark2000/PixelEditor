class_name PaintTool

var canvas setget set_canvas #画布
var color setget set_color #画笔颜色

func init(canvas_:Node, color_ = Color.black):
	canvas = canvas_
	color = color_
	assert(canvas.has_method("canvas_init"))

func paint_tool_update(_mpos: Vector2):
	assert(false)

func set_canvas(canvas_):
	canvas = canvas_
	
func set_color(color_):
	color = color_
