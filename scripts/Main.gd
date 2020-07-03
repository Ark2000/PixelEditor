extends Node2D

onready var canvas = $MyCanvas
onready var cursor = $Cursor

var last_draw:Vector2 = Vector2(-1, -1) #中间值，用于记录最后一次绘制的位置

var color1: Color = Color.black
var color2: Color = Color.transparent

func update_info():
	var mpos = get_canvas_pixel_position()
	var s = "mouse position: %.2f, %.2f"%[mpos.x, mpos.y]
	$GUI/VBoxContainer2/VBoxContainer/Line2.text = s
	
func _process(_delta):
	update_info()
	update_cursor()
	pencil()

func get_canvas_pixel_position() -> Vector2:
	var mpos = get_global_mouse_position()
	var half_canvas = canvas.get_bitmap_size() / 2
	mpos /= canvas.scale.x
	mpos += half_canvas
	mpos.x = floor(mpos.x)
	mpos.y = floor(mpos.y)
	return mpos

#更新指针的位置
func update_cursor():
	var tpos = (get_canvas_pixel_position() - canvas.get_bitmap_size() / 2) * 8
	$Tween.interpolate_property(cursor, "position", null, tpos, 0.037, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

#画笔
#TODO
#目前待解决的问题是：当鼠标移动过快时，笔画会出现不连续的现象
#需要做的事情是编写线性插值算法，补充中间漏掉的点
func pencil():
	var flag = false
	var color = color2
	if Input.is_action_pressed("right_select"):
		flag = true
	elif Input.is_action_pressed("left_select"):
		flag = true
		color = color1
	if flag:
		#获取画布像素坐标
		var mpos = get_canvas_pixel_position()
		if mpos == last_draw: return
		if not canvas.is_valid_pixelv(mpos): return
		last_draw = mpos
		canvas.set_pixelv(mpos, color)


#改变画笔颜色测试
func _on_ColorPicker_color_changed(color):
	color1 = color
