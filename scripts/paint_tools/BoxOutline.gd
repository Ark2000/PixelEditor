extends GeometryTool
class_name BoxOutline

func _init(canvas_:Node, color_ = Color.black):
	init(canvas_, color_)

func draw_api():
	var rect = Rect2()
	rect.position.x = min(p0.x, p1.x)
	rect.position.y = min(p0.y, p1.y)
	rect.end.x = max(p0.x, p1.x) + 1
	rect.end.y = max(p0.y, p1.y) + 1
	return canvas.set_pixel_rect(rect, color)

func operation_desc() -> String:
	return "draw rectangle box"
