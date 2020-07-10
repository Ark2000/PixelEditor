extends WindowDialog
signal set_canvas_bg_color

onready var color_rect = $VBoxContainer/HBoxContainer/TextureRect/ColorRect

func set_bbcode(bb:String):
	$VBoxContainer/RichTextLabel.bbcode_text = bb

func _on_RichTextLabel_meta_clicked(meta):
	var err = OS.shell_open(ProjectSettings.globalize_path(meta))
	assert(err == OK)

func _on_R_value_changed(value):
	color_rect.color.r = value / 255.0

func _on_G_value_changed(value):
	color_rect.color.g = value / 255.0

func _on_B_value_changed(value):
	color_rect.color.b = value / 255.0

func _on_A_value_changed(value):
	color_rect.color.a = value / 255.0


func _on_Button_pressed():
	emit_signal("set_canvas_bg_color", color_rect.color)
	visible = false
