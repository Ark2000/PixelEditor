extends WindowDialog

func set_content(file_folder:String, file_name):
	$VBoxContainer/RichTextLabel.bbcode_text = "[center]文件已保存为[color=#44FF44][url]" + file_folder + "[/url]" + file_name + "[/color][/center]"


func _on_RichTextLabel_meta_clicked(_meta):
	var err = OS.shell_open(ProjectSettings.globalize_path(_meta))
	if err != OK:
		print("error:" + err)


func _on_Confirm_pressed():
	visible = false
