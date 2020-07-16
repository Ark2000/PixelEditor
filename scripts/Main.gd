extends Node2D

var left_color := Color(0, 0, 0, 0)

onready var canvas = $PixelCanvas
onready var cursor = $Cursor
onready var paint_tool:PaintTool = Pencil.new(canvas, left_color)
onready var cpalette = $GUI/VBoxContainer/ColorPalette
onready var canpop = $GUI/CanvasInfo

func _ready():
	if not Globals.Init:
		TranslationServer.set_locale("en")
		Globals.Init = true
	FileManager.filesystem_init()
	canvas.canvas_init(32, 32)
	canvas.record("canvas initialized")
	Logger.Log("Canvas Initialized", LogEntry.TRIVIAL)

func update_info():
	var mpos = canvas.global_to_canvas_position(get_global_mouse_position())
	var s = "mouse position: %.2f, %.2f "%[mpos.x, mpos.y]
	if canvas.is_valid_pixelv(mpos):
		s += ("color:" + String(canvas.get_pixelv(mpos)))
	$GUI/VBoxContainer2/VBoxContainer/Line2.text = s
	
func _on_Focus_state_changed(s:String):
	$GUI/VBoxContainer2/VBoxContainer/Line1.text = s

func _process(_delta):
	update_info()
	update_cursor()
	
func _unhandled_input(_event):
	paint_tool.paint_tool_update(get_global_mouse_position())

func update_cursor():
	var mpos = canvas.global_to_canvas_position(get_global_mouse_position())
	if not canvas.get_bitmap_rect().has_point(mpos): return
	cursor.position = canvas.position + mpos * canvas.canvas_scale

func _on_ColorPalette_color_selected(c:Color):
	left_color = c
	paint_tool.set_color(c)
	Logger.Log("color selected", LogEntry.GENERIC, String(c))

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
	Logger.Log("Tool changed", LogEntry.GENERIC, "current tool: %d"%val)

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
	left_color = Color(0,0,0,0)
	paint_tool.set_color(cpalette.colors[0])
	canvas.canvas_init(form.w, form.h)
	canvas.set_file_name(form.file_name)
	canvas.palette_name = form.palette_name
	canvas.record("canvas initialized")
	Logger.Log("New file created", LogEntry.GENERIC, "filename:%s, size:%s, palette:%s"%[form.file_name, String(Vector2(form.w, form.h)), form.palette_name])

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
		"File Path: [color=#44FF44][url]" + Globals.USERART_SAVE_FOLDER + "[/url]" + canvas.file_name + "[/color]\n" + 
		"Palette Path: [color=#44FF44][url]" + Globals.PALETTES_FOLDER + "[/url]" + canvas.palette_name + "[/color]\n" + 
		"Canvas Size: " + String(canvas.width) + " * " + String(canvas.height)
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
	canvas.record("Clip canvas to %s"%String(clip))

func _on_CanvasFrame_framesize_changed(fsize, loc):
	var bsize = canvas.get_bitmap_size()
	if fsize == bsize: return
	if loc == "left" or loc == "top":
		var d = fsize - bsize
		if d.x > 0 or d.y > 0:
			canvas.canvas_clip(Rect2(Vector2(0, 0), fsize))
			canvas.overall_shift(d)
		else:
			canvas.overall_shift(d)
			canvas.canvas_clip(Rect2(Vector2(0, 0), fsize))
	else:
		canvas.canvas_clip(Rect2(Vector2(0, 0), fsize))
	canvas.record("Canvas size changed to %s"%fsize)
	
func _on_MenuBar_open_file():
	$GUI/OpenFileDialog.popup_centered()


func _on_OpenFileDialog_file_selected(path):
	var err = canvas.open_png(path)
	if err != null:
		$GUI/AcceptDialog.dialog_text = err
		$GUI/AcceptDialog.popup_centered()
		return
	canvas.record("Open png file from " + path)
