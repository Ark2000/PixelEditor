extends WindowDialog

signal form_submited

onready var wspin = $VBoxContainer/HBoxContainer/W
onready var hspin = $VBoxContainer/HBoxContainer2/H
onready var xspin = $VBoxContainer/HBoxContainer/X
onready var yspin = $VBoxContainer/HBoxContainer2/Y
onready var colloc = $VBoxContainer/HBoxContainer/ColLoc
onready var rowloc = $VBoxContainer/HBoxContainer2/RowLoc

var canvas_size

func set_limitation(limit:Vector2):
	canvas_size = limit

func _on_W_value_changed(value):
	xspin.max_value = abs(canvas_size.x - value)
	_on_ColLoc_item_selected(colloc.selected)

func _on_H_value_changed(value):
	yspin.max_value = abs(canvas_size.y - value)
	_on_RowLoc_item_selected(rowloc.selected)

func _on_ColLoc_item_selected(index):
	if index == 0:
		xspin.value = 0
	elif index == 1:
		xspin.value = abs(canvas_size.x - wspin.value) / 2
	elif index == 2:
		xspin.value = abs(canvas_size.x - wspin.value)

func _on_RowLoc_item_selected(index):
	if index == 0:
		yspin.value = 0
	elif index == 1:
		yspin.value = abs(canvas_size.y - hspin.value) / 2
	elif index == 2:
		yspin.value = abs(canvas_size.y - hspin.value)


func _on_Confirm_pressed():
	emit_signal("form_submited", Rect2(xspin.value, yspin.value, wspin.value, hspin.value))
	visible = false

func _on_Cancel_pressed():
	visible = false
