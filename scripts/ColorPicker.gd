extends ColorPicker
signal mouse_enterted_rect
signal mouse_exited_rect
var mouse_entered := false

var fullview_position:Vector2
var halfview_position:Vector2
const halfview_height = 470 #调色板在隐藏状态下的碰撞盒高度

func _ready():
	halfview_position = rect_position
	fullview_position = Vector2(rect_position.x, 0)
	
func _process(_delta):
	#直接获取视图鼠标坐标
	var mpos = get_tree().root.get_mouse_position()
	var rect = get_rect()
	if not mouse_entered:
		rect.size.y = halfview_height
	var hasp = rect.has_point(mpos)
	if hasp and not mouse_entered:
		mouse_entered = true
		emit_signal("mouse_enterted_rect")
	if not hasp and mouse_entered:
		mouse_entered = false
		emit_signal("mouse_exited_rect")

func _on_ColorPicker_mouse_enterted_rect():
	print("entered")
	$Tween.interpolate_property(self, "rect_position", null, Vector2(rect_position.x, fullview_position.y), 0.4, Tween.TRANS_QUINT, Tween.EASE_OUT)
	$Tween.start()



func _on_ColorPicker_mouse_exited_rect():
	print("exited")
	$Tween.interpolate_property(self, "rect_position", null,  Vector2(rect_position.x, halfview_position.y), 0.2, Tween.TRANS_LINEAR, Tween.EASE_IN)
	$Tween.start()
