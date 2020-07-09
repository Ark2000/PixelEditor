extends TextureRect

signal pressed

func _on_UndoButton_button_down():
	modulate = Color("2f4b6c")

func _on_UndoButton_button_up():
	modulate = Color("ffffff")
	emit_signal("pressed")
