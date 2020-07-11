extends WindowDialog
class_name NewFilePopup

var err = false

onready var pob = $VBoxContainer/HBoxContainer4/OptionButton
onready var ppr = $VBoxContainer/PalettePreview

func _ready():
	var palettes = FileManager.list_files_in_directory(Globals.PALETTES_FOLDER)
	for palette in palettes:
		pob.add_item(palette)
	load_palette_preview(0)
	_on_Filename_text_changed($VBoxContainer/HBoxContainer/Filename.text)

func _on_Button2_pressed():
	hide()

func _on_Button_pressed():
	if err: return
	var ob = $VBoxContainer/HBoxContainer4/OptionButton
	get_parent().emit_signal("new_file_form_submit", {
		"file_name": $VBoxContainer/HBoxContainer/Filename.text,
		"palette_name": ob.get_item_text(ob.get_selected_id()),
		"w": int($VBoxContainer/HBoxContainer2/W.get_line_edit().text),
		"h": int($VBoxContainer/HBoxContainer2/H.get_line_edit().text)
	})
	hide()

func _on_Filename_text_changed(new_text):
	err = false
	if new_text == "":
		$VBoxContainer/RichTextLabel.bbcode_text = "[color=#FF4444]- 请输入文件名[/color]"
		err = true
	else:
		$VBoxContainer/RichTextLabel.bbcode_text = "[color=#44FF44]- 参数正确[/color]"
	var fname = new_text + ".png"
	if FileManager.directory_has_file(fname, Globals.USERART_SAVE_FOLDER):
		$VBoxContainer/RichTextLabel.bbcode_text = "[color=#FFFF44]- 文件重复，将会覆盖[/color]"

static func generate_palette_preview(file_name) -> Image:
	var image = Image.new()
	var colors = ColorPalette.get_colors_from_String(FileManager.read_file_string(file_name))
	image.create(colors.size(), 1, false, Image.FORMAT_RGBA8)
	image.lock()
	for i in range(colors.size()):
		image.set_pixel(i, 0, colors[i])
	image.unlock()
	return image
	
func load_palette_preview(index:int):
	var first_palette_path = Globals.PALETTES_FOLDER + pob.get_item_text(index)
	var tex = ImageTexture.new()
	tex.create_from_image(generate_palette_preview(first_palette_path), 0)
	ppr.texture = tex

func _on_OptionButton_item_selected(index):
	load_palette_preview(index)
