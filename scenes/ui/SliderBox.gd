extends HBoxContainer

signal value_changed

export var text := "R"

func _ready():
	$Label.text = text

func _on_HSlider_value_changed(value):
	$SpinBox.value = value
	emit_signal("value_changed", value)

func _on_SpinBox_value_changed(value):
	$HSlider.value = value
	emit_signal("value_changed", value)

func get_value():
	return $SpinBox.value
