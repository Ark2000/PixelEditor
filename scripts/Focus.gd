extends Position2D

signal state_changed

#关于缩放要说明的一点是：假设缩放值是100/100%
#那么小于1时，分母线性变化（取倒）
#大于1时，分子线性变化
#这样做可以保持缩放不至于过于极端（太大或太小）

#还有一点就是，焦点坐标移动的距离=缩放*鼠标位移

const zoom_cap = 2.0  #缩放封顶
var zoom_value = 1 #中间值，主要用于平滑缩放

func _ready():
	emit_signal("state_changed", state_string())

func _unhandled_input(event):
	var flag = false
	var zoom_delta = 0
	if Input.is_action_pressed("move_canvas"):
		if event is InputEventMouseMotion:
			position -= event.relative * $Camera2D.zoom.x
			flag = true
	elif Input.is_action_just_pressed("zoom_in"):
		zoom_delta = -0.1
	elif Input.is_action_just_pressed("zoom_out"):
		zoom_delta = 0.1
	
	if zoom_delta != 0:
		flag = true
		if zoom_value >= 1:
			zoom_value += zoom_delta
		else:
			zoom_value = 10/(10/zoom_value - 10*zoom_delta)
		if zoom_value > zoom_cap: zoom_value = zoom_cap
		$Tween.interpolate_property($Camera2D, "zoom", $Camera2D.zoom, Vector2(zoom_value, zoom_value), 0.4, Tween.TRANS_CUBIC, Tween.EASE_OUT)
		$Tween.start()
	
	if flag:
		emit_signal("state_changed", state_string())


func state_string() -> String:
	return "zoom:%.1f%% camera position: %.1f, %.1f"%[zoom_value * 100, position.x, position.y]
