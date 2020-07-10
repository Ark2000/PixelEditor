extends GeometryTool
class_name Dragger

func _init(canvas_:Node, color_ = Color.black):
	init(canvas_, color_)

func draw_api():
	return canvas.overall_shift(p1 - p0)

func operation_desc() -> String:
	return "overall offset"
