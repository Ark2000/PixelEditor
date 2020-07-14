extends TextureRect
signal tool_selected

export var id = 0

func _on_Button_pressed():
	emit_signal("tool_selected", self)

func set_frame_vis(val):
	$ColorRect.visible = val

func get_id():
	return id
