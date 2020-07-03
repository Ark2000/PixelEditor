extends Node2D

signal bitmap_changed

export var grid := false
export var grid_size := 4

var bitmap: PoolColorArray
var width := 0
var height := 0

#初始化画布，分配内存
func canvas_init(w: int, h: int):
	self.width = w
	self.height = h
	bitmap = PoolColorArray([])
	for _i in range(width * height):
		bitmap.push_back(Color(0.0, 0.0, 0.0, 0.0))
	emit_signal("bitmap_changed")
	
	#居中摆放画布
	position = Vector2(-width, -height) * scale / 2

#检查越界
func is_valid_pixel(x:int, y:int) -> bool:
	if x < 0 or x >= width or y < 0 or y >= height:
		return false
	return true
func is_valid_pixelv(p:Vector2) -> bool:
	return is_valid_pixel(int(p.x), int(p.y))

#setget pixel
func set_pixel(x:int, y:int, c:Color, esignal=true):
	assert(is_valid_pixel(x, y))
	bitmap.set(y * width + x, c)
	if esignal:
		emit_signal("bitmap_changed")
func set_pixelv(p: Vector2, c:Color, esignal=true):
	set_pixel(int(p.x), int(p.y), c, esignal)
func get_pixel(x:int, y:int) -> Color:
	assert(is_valid_pixel(x, y))
	return bitmap[y * width + x]
func get_pixelv(p: Vector2) -> Color:
	return get_pixel(int(p.x), int(p.y))
func get_bitmap_size():
	return Vector2(width, height)

#生成
func generate_chaos_bitmap():
	for y in range(height):
		for x in range(width):
			var color = Color(rand_range(0.0, 1.0), rand_range(0.0, 1.0), rand_range(0.0, 1.0))
			set_pixel(x, y, color, false)
	emit_signal("bitmap_changed")

func _ready():
	canvas_init(32, 32)
	
func _draw():
	for y in range(height):
		for x in range(width):
			draw_rect(Rect2(x, y, 1, 1), get_pixel(x, y))
	draw_grid()
			
func draw_grid():
	#画一个框出来
	draw_line(Vector2(0, 0), Vector2(width, 0), Color.cyan)
	draw_line(Vector2(0, height), Vector2(width, height), Color.cyan)
	draw_line(Vector2(0, 0), Vector2(0, height), Color.cyan)
	draw_line(Vector2(width, 0), Vector2(width, height), Color.cyan)
	#画网格
	if not grid: return
	for x in range(grid_size, width, grid_size):
		draw_line(Vector2(x, 0), Vector2(x, height), Color.cyan)
	for y in range(grid_size, height, grid_size):
		draw_line(Vector2(0, y), Vector2(width, y), Color.cyan)
		
func save_as_png():
	#简单粗暴的方法，直接套API
	var image = Image.new()
	image.create(width, height, false, Image.FORMAT_RGBA8)
	image.lock()
	for y in range(height):
		for x in range(width):
			image.set_pixel(x, y, get_pixel(x, y))
	image.unlock()
	image.save_png("user://image.png")
	
func open_png():
	var image = Image.new()
	image.load("user://icon.png")
	canvas_init(image.get_width(), image.get_height())
	image.lock()
	for y in range(height):
		for x in range(width):
			set_pixel(x, y, image.get_pixel(x, y), false)
	emit_signal("bitmap_changed")
	

func _on_MyCanvas_bitmap_changed():
	update()
	print("update")


#仅用于测试
func test():
	if Input.is_action_just_pressed("ui_left"):
		generate_chaos_bitmap()
	if Input.is_action_just_pressed("ui_right"):
		grid = !grid
		emit_signal("bitmap_changed")
	if Input.is_action_just_pressed("ui_up"):
		save_as_png()
		print("图像已保存为PNG")
	if Input.is_action_just_pressed("ui_down"):
		open_png()
		print("已打开图像")
		
func _process(_delta):
	test()
