extends WindowDialog

onready var text_area = $VBoxContainer/RichTextLabel

var lines:PoolStringArray
var tags:PoolIntArray

func _ready():
	var err = Logger.connect("add_new_line", self, "_on_add_new_line")
	assert(err == OK)

func _clear_text_area():
	text_area.bbcode_text = ""
	lines = PoolStringArray()
	tags = PoolIntArray()
	
func _reload_text_area():
	_clear_text_area()
	for e in Logger.entries:
		var s = Logger._entry_to_string(e)
		_add_new_line(s)
		lines.append(s)
		tags.append(e.tag)

func _add_new_line(s:String):
		text_area.bbcode_text += (s + "\n")

func _on_add_new_line(s:String, t):
	_add_new_line(s)
	lines.append(s)
	tags.append(t)

func _on_Button_pressed():
	_clear_text_area()

func _on_Button3_pressed():
	_reload_text_area()


func _on_Button2_pressed():
	OS.clipboard = text_area.text

func filtrate(lv:int):
	text_area.bbcode_text = ""
	for i in range(lines.size()):
		if tags[i] >= lv:
			_add_new_line(lines[i])

func _on_OptionButton_item_selected(index):
	filtrate(index)
