extends Panel

onready var file_section = $HBoxContainer/MenuButton
onready var help_section = $HBoxContainer/MenuButton2

func _ready():
	file_section.get_popup().connect("id_pressed", self, "_on_file_section_id_pressed")
	help_section.get_popup().connect("id_pressed", self, "_on_help_section_id_pressed")
	
func _on_file_section_id_pressed(id:int):
	if id == 0:
		$new_file_pop_window.popup_centered()
	elif id == 1:
		get_tree().quit()

func _on_help_section_id_pressed(id:int):
	if id == 0:
		$AboutPopup.popup_centered()
