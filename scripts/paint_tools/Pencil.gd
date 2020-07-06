extends PaintTool
class_name Pencil

var last_position
var last_color

func _init(canvas_:Node, layer:Node, color_ = Color.black):
	canvas = canvas_
	color = color_
	helper_layer = layer
	assert(canvas.has_method("canvas_init"))
	assert(layer.has_method("canvas_init"))

#传入鼠标坐标
func paint_tool_update(mpos:Vector2):
	var draw_flag = false

	if Input.is_action_pressed("left_select"):
		draw_flag = true

	if draw_flag:
		#转化为画布像素坐标
		mpos = canvas.global_to_canvas_position(mpos)
		if mpos == last_position and color == last_color: return
		if last_position:
			canvas.set_pixel_line(mpos, last_position, color)
		else:
			if canvas.is_valid_pixelv(mpos):
				canvas.set_pixelv(mpos, color)
		last_position = mpos
		last_color = color
	else:
		last_position = null
		last_color = null
