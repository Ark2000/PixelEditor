extends PaintTool
class_name BoxOutline

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
		print("???")
		canvas.set_pixel_rect(get_box(), color)
		p0 = null
		p1 = null
	if p0 != null:
		if mpos != p1:
			p1 = mpos
			helper_layer.clear()
			helper_layer.set_pixel_rect(get_box(), color)
			
func get_box() -> Rect2:
	var rect = Rect2()
	rect.position.x = min(p0.x, p1.x)
	rect.position.y = min(p0.y, p1.y)
	rect.end.x = max(p0.x, p1.x) + 1
	rect.end.y = max(p0.y, p1.y) + 1
	return rect
