extends Control

signal framesize_changed

var frame_size = Vector2(32, 32)

var para1 = 4 #边角料
var para2 = 8 #边框缩放
var para3 = 2 #固定外边距

func _ready():
	update_arrows()

func update_arrows():
	$Arrow.init()
	$Arrow2.init()
	$Arrow3.init()
	$Arrow4.init()

func set_frame_size(s:Vector2):
	frame_size = s
	$toptag.text = String(s.x) + "px"
	$bottomtag.text = String(s.x) + "px"
	$lefttag.text = String(s.y) + "px"
	$righttag.text = String(s.y) + "px"
	
	var sv = $lefttag.get_combined_minimum_size()
	$lefttag.rect_position = Vector2(-sv.y - para2 * para3, sv.x - para2 * para3)
	sv = $righttag.get_combined_minimum_size()
	$righttag.rect_position = Vector2(s.x * para2 + sv.y + para2 * para3, s.y * para2 - sv.x + para2 * para3)
	sv = $toptag.get_combined_minimum_size()
	$toptag.rect_position = Vector2(s.x * para2 - sv.x + para2 * para3, -sv.y - para2 * para3)
	$bottomtag.rect_position = Vector2(-para2 * para3, s.y * para2 + para2 * para3)
	
	$topL.set_point_position(0, Vector2(-para1, -para3) * para2)
	$topL.set_point_position(1, Vector2(s.x + para1, -para3) * para2)
	$bottomL.set_point_position(0, Vector2(-para1, s.y + para3) * para2)
	$bottomL.set_point_position(1, Vector2(s.x + para1, s.y + para3) * para2)
	$leftL.set_point_position(0, Vector2(-para3, -para1) * para2)
	$leftL.set_point_position(1, Vector2(-para3, s.y + para1) * para2)
	$rightL.set_point_position(0, Vector2(s.x + para3, -para1) * para2)
	$rightL.set_point_position(1, Vector2(s.x + para3, s.y + para1) * para2)



func _on_PixelCanvas_bitmap_init(s, p):
	set_frame_size(s)
	rect_position = p
	update_arrows()
	
func get_topleft() -> Vector2:
	return Vector2(-para3, -para3) * para2

func get_topright() -> Vector2:
	return Vector2(frame_size.x + para3, -para3) * para2
	
func get_lowerleft() -> Vector2:
	return Vector2(-para3, frame_size.y + para3) * para2
	
func get_lowerright() -> Vector2:
	return Vector2(frame_size.x + para3, frame_size.y + para3) * para2

var vloc
func _on_Arrow_size_changed(loc, del):
	vloc = loc
	if loc == "left" or loc == "top":
		set_frame_size(frame_size - del)
		rect_position += del * para2
	else:
		set_frame_size(frame_size + del)
		
	update_arrows()


func _on_Arrow_end():
	emit_signal("framesize_changed", frame_size, vloc)
