extends WindowDialog

func _on_Confirm_pressed():
	get_parent().emit_signal("grid_settings_form_submit", {
		"show_grid": $VBoxContainer/CheckBox.pressed,
		"x": $VBoxContainer/HBoxContainer/X.get_line_edit().text.to_int(),
		"y": $VBoxContainer/HBoxContainer/Y.get_line_edit().text.to_int(),
		"w": $VBoxContainer/HBoxContainer2/W.get_line_edit().text.to_int(),
		"h": $VBoxContainer/HBoxContainer2/H.get_line_edit().text.to_int()
	})
	visible = false

func _on_Cancel_pressed():
	visible = false
