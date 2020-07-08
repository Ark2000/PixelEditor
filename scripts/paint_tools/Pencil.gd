extends PaintTool
class_name Pencil

var last_position
var last_color
var draw_flag = false
var update_flag = false

func _init(canvas_:Node, color_ = Color.black):
	init(canvas_, color_)

#传入鼠标坐标
func paint_tool_update(mpos:Vector2):
	if Input.is_action_just_pressed("left_select"):
		draw_flag = true
	if Input.is_action_just_released("left_select"):
		draw_flag = false
		last_position = null
		last_color = null
		if update_flag:
			canvas.take_snapshot("draw pixels")
			update_flag = false

	if draw_flag:
		#转化为画布像素坐标
		mpos = canvas.global_to_canvas_position(mpos)
		if mpos == last_position and color == last_color: return
		if last_position:
			var flag = canvas.set_pixel_line(mpos, last_position, color)
			update_flag = update_flag or flag
		else:
			if canvas.is_valid_pixelv(mpos):
				canvas.set_pixelv(mpos, color)
				update_flag = true
		last_position = mpos
		last_color = color

