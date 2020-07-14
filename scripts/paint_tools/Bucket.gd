extends PaintTool
class_name Bucket

func _init(canvas_:Node, color_ = Color.black):
	init(canvas_, color_)

var p0

#传入鼠标坐标
func paint_tool_update(mpos:Vector2):
	if Input.is_action_just_pressed("left_select"):
		mpos = canvas.global_to_canvas_position(mpos)
		if canvas.is_valid_pixelv(mpos):
			p0 = mpos
	elif Input.is_action_just_released("left_select") and p0 != null:
		mpos = canvas.global_to_canvas_position(mpos)
		if canvas.is_valid_pixelv(mpos):
			canvas.flood_fill(p0, color)
			canvas.record("bucket flood fill")
		p0 = null
