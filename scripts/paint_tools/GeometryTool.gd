extends PaintTool
class_name GeometryTool

var p0
var p1
var bitmap_temp
var update_flag

func operation_desc() -> String:
	return ""

func draw_api() -> bool:
	return false

func paint_tool_update(mpos:Vector2):
	mpos = canvas.global_to_canvas_position(mpos)
	if Input.is_action_just_pressed("left_select"):
		p0 = mpos
		bitmap_temp = canvas.get_bitmap_copy()
		update_flag = false
	if Input.is_action_just_released("left_select"):
		p0 = null
		p1 = null
		bitmap_temp = null
		if update_flag:
			canvas.record(operation_desc())

	if p0 != null:
		if not Input.is_action_pressed("left_select"):
			p0 = null
			return
		if mpos != p1:
			p1 = mpos
			canvas.set_bitmap(bitmap_temp)
			update_flag = draw_api()
