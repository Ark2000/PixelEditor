extends Control

var labels = []
const lines = 7
var curline = 0

func _ready():
	labels.append($VBoxContainer/Label)
	for _i in range(lines-1):
		var node = labels[0].duplicate()
		labels.append(node)
		$VBoxContainer.add_child(node)
		
	var err = Logger.connect("add_new_line_pure", self, "_on_add_new_line")
	assert(err == OK)
	
func _on_add_new_line(s:String, _t):
	line_in(s)

func line_in(s:String):
	if curline == lines:
		line_out()
	labels[curline].text = s
	curline += 1
	$Timer.start()
	
func line_out():
	if curline > 0:
		for i in range(1, curline):
			labels[i - 1].text = labels[i].text
		labels[curline - 1].text = ""
		curline -= 1

func _on_Timer_timeout():
	line_out()
