extends WindowDialog

func set_bbcode(bb:String):
	$VBoxContainer/RichTextLabel.bbcode_text = bb

func _on_RichTextLabel_meta_clicked(meta):
	var err = OS.shell_open(ProjectSettings.globalize_path(meta))
	assert(err == OK)
