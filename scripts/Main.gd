extends Node2D

onready var canvas = $PixelCanvas
onready var cursor = $Cursor

onready var paint_tool:PaintTool = Pencil.new(canvas, Color.black)

var left_color := Color.transparent

onready var cpalette = $GUI/VBoxContainer/ColorPalette
onready var canpop = $GUI/CanvasInfo

func _ready():
	FileManager.filesystem_init()

func update_info():
	var mpos = canvas.global_to_canvas_position(get_global_mouse_position())
	var s = "mouse position: %.2f, %.2f"%[mpos.x, mpos.y]
	$GUI/VBoxContainer2/VBoxContainer/Line2.text = s
	
func _on_Focus_state_changed(s:String):
	$GUI/VBoxContainer2/VBoxContainer/Line1.text = s

func _process(_delta):
	update_info()
	update_cursor()
	
func _unhandled_input(_event):
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

func _on_Button9_pressed():
	canvas.clear()

func _on_Button10_pressed():
	var s = Vector2(16, 16)
	s.x += randi() % 64
	s.y += randi() % 64
	canvas.canvas_init(s.x, s.y)

func _on_Button11_pressed():
	canvas.undo()

func _on_Button12_pressed():
	canvas.redo()

func _on_ColorPalette_color_selected(c:Color):
	left_color = c
	paint_tool.set_color(c)

func _on_ToolPanel_selection_update(val):
	if val == ToolPanel.PENCIL:
		paint_tool = Pencil.new(canvas, left_color)
	elif val == ToolPanel.RULER:
		paint_tool = Line.new(canvas, left_color)
	elif val == ToolPanel.RECT:
		paint_tool = BoxOutline.new(canvas, left_color)
	elif val == ToolPanel.RECTS:
		paint_tool = FilledBox.new(canvas, left_color)
	elif val == ToolPanel.BUCKET:
		paint_tool = Bucket.new(canvas, left_color)
	elif val == ToolPanel.DRAGGER:
		paint_tool = Dragger.new(canvas, left_color)

func _on_MenuBar_save_file():
	$GUI/SaveFileSettingsPopup.set_content(canvas.file_name, canvas.get_bitmap_size())
	$GUI/SaveFileSettingsPopup.popup_centered()
	
func _on_SaveFileSettingsPopup_save_file_form_submited(fname:String, imgscale:int):
	canvas.file_name = fname
	canvas.save_as_png(imgscale)
	$GUI/SaveFilePopup.set_content(Globals.USERART_SAVE_FOLDER, canvas.file_name + ".png")
	$GUI/SaveFilePopup.popup_centered()

func _on_MenuBar_new_file_form_submit(form):
	cpalette.set_colors_s(FileManager.read_file_string(Globals.PALETTES_FOLDER + form.palette_name))
	paint_tool.set_color(cpalette.colors[0])
	canvas.canvas_init(form.w, form.h)
	canvas.set_file_name(form.file_name)
	canvas.palette_name = form.palette_name
	canvas.record("canvas initialized")

func _on_ToolPanel_undo_btn_pressed():
	canvas.undo()

func _on_ToolPanel_redo_btn_pressed():
	canvas.redo()

func _on_MenuBar_grid_settings_form_submit(form):
	canvas.set_show_grid(form.show_grid)
	canvas.set_grid_size(Vector2(form.w, form.h))
	canvas.set_grid_offset(Vector2(form.x, form.y))

func _on_MenuBar_canvas_info():
	canpop.set_bbcode(
		"文件路径: [color=#44FF44][url]" + Globals.USERART_SAVE_FOLDER + "[/url]" + canvas.file_name + "[/color]\n" + 
		"调色板路径: [color=#44FF44][url]" + Globals.PALETTES_FOLDER + "[/url]" + canvas.palette_name + "[/color]\n" + 
		"画布尺寸: " + String(canvas.width) + " * " + String(canvas.height)
	)
	canpop.popup_centered()

func _on_MenuBar_undo():
	canvas.undo()

func _on_MenuBar_redo():
	canvas.redo()

func _on_MenuBar_clear_canvas():
	canvas.clear()

func _on_MenuBar_set_canvas_bg_color(c:Color):
	canvas.set_bg_color(c)

func _on_MenuBar_set_canvas_clip():
	$GUI/CanvasClipPopup.set_limitation(canvas.get_bitmap_size())
	$GUI/CanvasClipPopup.popup_centered()

func _on_CanvasClipPopup_form_submited(clip:Rect2):
	canvas.canvas_clip(clip)
	canvas.record("change canvas size")
