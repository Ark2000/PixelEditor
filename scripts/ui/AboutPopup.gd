extends WindowDialog


func _on_Author_meta_clicked(meta):
	var err = OS.shell_open("mailto:"+meta)
	assert(err == OK)
