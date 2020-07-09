extends WindowDialog


func _on_Author_meta_clicked(meta):
	OS.shell_open("mailto:"+meta)
