extends GeometryTool
class_name Line

func _init(canvas_:Node, color_ = Color.black):
	init(canvas_, color_)

func draw_api():
	return canvas.set_pixel_line(p0, p1, color)

func operation_desc() -> String:
	return "draw line"
