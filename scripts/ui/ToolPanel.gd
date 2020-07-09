extends Panel
class_name ToolPanel
signal selection_update
signal undo_btn_pressed
signal redo_btn_pressed

enum {
	PENCIL,
	RULER,
	RECT,
	RECTS
}

var current_selected := PENCIL setget set_current_selected

func set_current_selected(val):
	if val != current_selected:
		emit_signal("selection_update", val)
	current_selected = val

func selectedbg_move(p:Vector2):
	$Tween.interpolate_property($SelectedBg, "rect_position", null, p + Vector2(4, 4), 0.1, Tween.TRANS_CUBIC, Tween.EASE_OUT)
	$Tween.start()

func _on_PencilButton_pressed():
	self.current_selected = PENCIL
	selectedbg_move($GridContainer/Pencil.rect_position)

func _on_RulerButton_pressed():
	self.current_selected = RULER
	selectedbg_move($GridContainer/Ruler.rect_position)

func _on_RectButton_pressed():
	self.current_selected = RECT
	selectedbg_move($GridContainer/Rect.rect_position)

func _on_RectSButton_pressed():
	self.current_selected = RECTS
	selectedbg_move($GridContainer/RectS.rect_position)

func _on_Undo_pressed():
	emit_signal("undo_btn_pressed")


func _on_Redo_pressed():
	emit_signal("redo_btn_pressed")
