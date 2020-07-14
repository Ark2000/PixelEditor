extends Panel
class_name ToolPanel
signal selection_update
signal undo_btn_pressed
signal redo_btn_pressed

enum {
	PENCIL,
	RULER,
	RECT,
	RECTS,
	BUCKET,
	DRAGGER
}

var cur_node

func _ready():
	cur_node = $VBoxContainer/GridContainer/Pencil
	cur_node.set_frame_vis(true)

func _on_Undo_pressed():
	emit_signal("undo_btn_pressed")

func _on_Redo_pressed():
	emit_signal("redo_btn_pressed")

func _on_tool_selected(node):
	if cur_node == node: return
	cur_node.set_frame_vis(false)
	cur_node = node
	cur_node.set_frame_vis(true)
	emit_signal("selection_update", cur_node.get_id())
