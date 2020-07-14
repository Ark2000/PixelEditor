extends ColorRect
signal color_selected

func _on_Button_pressed():
	emit_signal("color_selected", self)

func set_frame_vis(val):
	$frame.visible = val
