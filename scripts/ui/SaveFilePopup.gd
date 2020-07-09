extends WindowDialog

#func _ready():
#	popup()
#	set_file_path("C:\\Users\\root\\Downloads\\abacus.png")

func set_file_path(file_path:String):
	$VBoxContainer/RichTextLabel.bbcode_text = "[center]文件已保存为[color=#44FF44][url]" + file_path + "[/url][/color][/center]"


func _on_RichTextLabel_meta_clicked(_meta):
	var err = OS.shell_open(ProjectSettings.globalize_path(NewFilePopup.default_path))
	if err != OK:
		print("error:" + err)


func _on_Confirm_pressed():
	visible = false
