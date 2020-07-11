extends WindowDialog

signal save_file_form_submited

var err := false

onready var fname = $VBoxContainer/HBoxContainer/FileName
onready var rtl = $VBoxContainer/RichTextLabel
onready var img_scale = $VBoxContainer/HBoxContainer2/ImgScale

var csize

func set_content(file_name:String, canvas_size:Vector2):
	fname.text = file_name
	_on_FileName_text_changed(file_name)
	csize = canvas_size

func _on_FileName_text_changed(new_text):
	err = false
	if new_text == "":
		rtl.bbcode_text = "[color=#FF4444]- 请输入文件名[/color]"
		err = true
	else:
		rtl.bbcode_text = "[color=#44FF44]- 参数正确[/color]"
	var ffname = new_text + ".png"
	if FileManager.directory_has_file(ffname, Globals.USERART_SAVE_FOLDER):
		rtl.bbcode_text = "[color=#FFFF44]- 文件重复，将会覆盖[/color]"

func _on_ImgScale_value_changed(value:float):
	print(value)
	$VBoxContainer/HBoxContainer4/ImgInfo.text = "预计图像尺寸：" + String(csize.x * value) + " x " + String(csize.y * value)

func _on_Confirm_pressed():
	if err: return
	emit_signal("save_file_form_submited", fname.text, img_scale.value)
	visible = false

func _on_Cancel_pressed():
	visible = false
