extends Node2D

onready var canvas = $PixelCanvas
onready var cursor = $Cursor

onready var paint_tool:PaintTool = Pencil.new(canvas, Color.black)

var left_color := Color.transparent

func update_info():
	var mpos = canvas.global_to_canvas_position(get_global_mouse_position())
	var s = "mouse position: %.2f, %.2f"%[mpos.x, mpos.y]
	$GUI/VBoxContainer2/VBoxContainer/Line2.text = s
	
func _on_Focus_state_changed(s:String):
	$GUI/VBoxContainer2/VBoxContainer/Line1.text = s

func _process(_delta):
	update_info()
	update_cursor()
	paint_tool.paint_tool_update(get_global_mouse_position())

#更新指针的位置
func update_cursor():
	var mpos = canvas.global_to_canvas_position(get_global_mouse_position())
	if not canvas.get_bitmap_rect().has_point(mpos): return
	var tpos = (mpos - canvas.get_bitmap_size() / 2) * canvas.canvas_scale
	$Tween.interpolate_property(cursor, "position", null, tpos, 0.037, Tween.TRANS_LINEAR, Tween.EASE_IN_OUT)
	$Tween.start()

func _on_Button_pressed():
	canvas.save_as_png()

func _on_Button2_pressed():
	canvas.open_png()

func _on_Button3_pressed():
	canvas.generate_chaos_bitmap()

func _on_Button4_pressed():
	canvas.switch_grid_display()

func _on_Button6_pressed():
	paint_tool = Pencil.new(canvas, left_color)

func _on_Button5_pressed():
	paint_tool = Line.new(canvas, left_color)

func _on_Button9_pressed():
	canvas.clear()

func _on_Button10_pressed():
	var s = Vector2(16, 16)
	s.x += randi() % 64
	s.y += randi() % 64
	canvas.canvas_init(s.x, s.y)

func _on_Button8_pressed():
	paint_tool = FilledBox.new(canvas, left_color)

func _on_Button7_pressed():
	paint_tool = BoxOutline.new(canvas, left_color)


func _on_Button11_pressed():
	canvas.undo()

func _on_Button12_pressed():
	canvas.redo()


func _on_ColorPalette_color_selected(c:Color):
	left_color = c
	paint_tool.set_color(c)


func _on_new_file_pop_window_form_submit(form):
	$tempGUI/ColorPalette.set_colors_s(FileManager.read_file_string(form.palette))
	canvas.canvas_init(form.w, form.h)
	canvas.set_file_path(form.file)
