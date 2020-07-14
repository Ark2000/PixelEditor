extends Control

signal size_changed
signal end

const para1 = 16
const unit_size = 8
export(String, "top", "bottom", "left", "right") var location

onready var arrow = $TextureRect
onready var counters = $Counters

var p0
var delta = Vector2.ZERO
func _input(_event):
	if not counters.visible: return
	if Input.is_action_just_pressed("left_select"):
		p0 = get_global_mouse_position()
		delta = Vector2.ZERO
	if Input.is_action_just_released("left_select"):
		emit_signal("end")
		p0 = null
		counters.get_child(0).text = "0px"
	if Input.is_action_pressed("left_select") and p0:
		var tmp
		if location == "left" or location == "right":
			tmp = Vector2(int((get_global_mouse_position() - p0).x / unit_size) * unit_size, 0)
		else:
			tmp = Vector2(0, int((get_global_mouse_position() - p0).y / unit_size) * unit_size)
		if tmp != delta:
			emit_signal("size_changed", location, (tmp - delta) / unit_size)
			rect_position += (tmp - delta)
			delta = tmp
			if location == "left" or location == "right":
				counters.get_child(0).text = String(tmp.x / unit_size) + "px"
			else:
				counters.get_child(0).text = String(tmp.y / unit_size) + "px"

func init():
	var topright = get_parent().get_topright()
	var lowerright = get_parent().get_lowerright()
	var topleft = get_parent().get_topleft()
	var lowerleft = get_parent().get_lowerleft()
	if location == "top":
		rect_rotation = -90
		rect_position = (topleft + topright) / 2 + Vector2(-arrow.rect_size.x/2, -para1)
	elif location == "right":
		rect_rotation = 0
		rect_position = (topright + lowerright) / 2 + Vector2(para1, -arrow.rect_size.y / 2)
	elif location == "left":
		rect_rotation = 180
		rect_position = (topleft + lowerleft) / 2 + Vector2(-para1, arrow.rect_size.y/2)
	elif location == "bottom":
		rect_rotation = 90
		rect_position = (lowerleft + lowerright) / 2 + Vector2(arrow.rect_size.x/2, para1)

	for child in counters.get_children():
		if child.name != location:
			counters.remove_child(child)

func _on_TextureRect_mouse_entered():
	arrow.modulate = Color("#44FF44")
	counters.visible = true

func _on_TextureRect_mouse_exited():
	arrow.modulate = Color.white
	counters.visible = false
