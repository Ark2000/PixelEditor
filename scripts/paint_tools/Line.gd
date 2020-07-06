extends PaintTool
class_name Line

var p0
var p1

func _init(canvas_:Node, layer:Node, color_ = Color.black):
	canvas = canvas_
	color = color_
	helper_layer = layer
	assert(canvas.has_method("canvas_init"))
	assert(layer.has_method("canvas_init"))

func paint_tool_update(mpos:Vector2):
	mpos = canvas.global_to_canvas_position(mpos)
	if Input.is_action_just_pressed("left_select"):
		p0 = mpos
		p1 = mpos
	if Input.is_action_just_released("left_select"):
		if p0 == null or p1 == null: return
		helper_layer.clear()
		canvas.set_pixel_line(p0, p1, color)
		p0 = null
		p1 = null
	if p0 != null:
		if mpos != p1:
			p1 = mpos
			helper_layer.clear()
			helper_layer.set_pixel_line(p0, p1, color)
