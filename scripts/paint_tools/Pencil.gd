extends PaintTool
class_name Pencil

var last_position
var last_color
var points:PoolVector2Array
var draw_flag = false

func _init(canvas_:Node, layer:Node, color_ = Color.black):
	canvas = canvas_
	color = color_
	helper_layer = layer
	assert(canvas.has_method("canvas_init"))
	assert(layer.has_method("canvas_init"))

#传入鼠标坐标
func paint_tool_update(mpos:Vector2):
	if Input.is_action_just_pressed("left_select"):
		draw_flag = true
	if Input.is_action_just_released("left_select"):
		draw_flag = false
		last_position = null
		last_color = null
		helper_layer.clear()
		if points.size() > 0:
			canvas.set_pixels(points, color)
			points = PoolVector2Array()

	if draw_flag:
		#转化为画布像素坐标
		mpos = canvas.global_to_canvas_position(mpos)
		if mpos == last_position and color == last_color: return
		if last_position:
			helper_layer.set_pixel_line(mpos, last_position, color)
			points.append_array(canvas.bresenham(mpos, last_position))
		else:
			if canvas.is_valid_pixelv(mpos):
				helper_layer.set_pixelv(mpos, color)
				points.append(mpos)
		last_position = mpos
		last_color = color

