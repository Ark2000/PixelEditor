extends WindowDialog

signal color_confirmed

export var hint_text := "提示信息"

var color := Color.transparent

onready var crect = $VBoxContainer/HBoxContainer/TextureRect/ColorRect

func _ready():
	$VBoxContainer/Hint.text = hint_text

func _on_Confirm_pressed():
	emit_signal("color_confirmed", color)
	visible = false

func _on_Cancel_pressed():
	visible  = false

func _on_R_value_changed(val):
	color.r8 = val
	crect.color = color

func _on_G_value_changed(val):
	color.g8 = val
	crect.color = color

func _on_B_value_changed(val):
	color.b8 = val
	crect.color = color

func _on_A_value_changed(val):
	color.a8 = val
	crect.color = color
