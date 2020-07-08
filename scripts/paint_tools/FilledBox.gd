extends GeometryTool
class_name FilledBox

func _init(canvas_:Node, layer:Node, color_ = Color.black):
	init(canvas_, layer, color_)

func draw_api():
	var rect = Rect2()
	rect.position.x = min(p0.x, p1.x)
	rect.position.y = min(p0.y, p1.y)
	rect.end.x = max(p0.x, p1.x) + 1
	rect.end.y = max(p0.y, p1.y) + 1
	return canvas.set_pixel_filled_rect(rect, color)

func operation_desc() -> String:
	return "draw filled rect"
