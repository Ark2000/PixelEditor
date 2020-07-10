extends Panel

signal save_file
signal new_file_form_submit
signal grid_settings_form_submit
signal canvas_info

onready var file_section = $HBoxContainer/MenuButton
onready var help_section = $HBoxContainer/MenuButton2
onready var view_section = $HBoxContainer/MenuButton3

func _ready():
	file_section.get_popup().connect("id_pressed", self, "_on_file_section_id_pressed")
	help_section.get_popup().connect("id_pressed", self, "_on_help_section_id_pressed")
	view_section.get_popup().connect("id_pressed", self, "_on_view_section_id_pressed")
	
func _on_file_section_id_pressed(id:int):
	if id == 0:
		$new_file_pop_window.popup_centered()
	elif id == 1:
		emit_signal("save_file")
	elif id == 2:
		get_tree().quit()

func _on_help_section_id_pressed(id:int):
	if id == 0:
		$AboutPopup.popup_centered()
	elif id == 2:
		var err = OS.shell_open("https://github.com/Ark2000/PixelEditor")
		assert(err == OK)
	elif id == 1:
		var err = OS.shell_open(ProjectSettings.globalize_path("user://"))
		assert(err == OK)

func _on_view_section_id_pressed(id:int):
	if id == 0:
		$GridSettings.popup_centered()
	elif id == 1:
		emit_signal("canvas_info")
