extends Node2D

signal bitmap_changed
signal bitmap_init

const canvas_scale = 8
const grid_color = Color.cyan
const max_history_cache = 100 #保留的历史数（用于回撤功能）

export var record_history = false
var history_pointer #指向最近的一次历史记录
var show_grid := false
var grid_size := 1

var bitmap_cache: Array
var bitmap: PoolColorArray
var width := 0
var height := 0

func _ready():
	scale = Vector2(canvas_scale, canvas_scale)
	canvas_init(32, 32)

#初始化画布，分配内存
func canvas_init(w: int, h: int):
	self.width = w
	self.height = h
	bitmap = PoolColorArray([])
	for _i in range(width * height):
		bitmap.push_back(Color(0.0, 0.0, 0.0, 0.0))
	emit_signal("bitmap_changed")
	#居中摆放画布
	position = Vector2(-width, -height) * canvas_scale / 2
	emit_signal("bitmap_init", Vector2(w, h))
	
	#清空历史缓存
	bitmap_cache = []
	history_pointer = -1
	take_snapshot("canvas initialized")

#检查越界
func is_valid_pixel(x, y) -> bool:
	if x < 0 or x >= width or y < 0 or y >= height:
		return false
	return true
func is_valid_pixelv(p:Vector2) -> bool:
	return is_valid_pixel(int(p.x), int(p.y))

#setget pixel
func set_pixel(x, y, c:Color, esignal=true):
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
func get_bitmap_rect():
	var rect = Rect2()
	rect.position = Vector2(0, 0)
	rect.size = Vector2(width, height)
	return rect
	
func switch_grid_display():
	show_grid = !show_grid
	emit_signal("bitmap_changed")

#将传入的全局坐标转化为位图坐标
func global_to_canvas_position(var mpos:Vector2) -> Vector2:
	#居中摆放的画布,需要额外的转换
	var half_canvas = get_bitmap_size() / 2
	mpos /= canvas_scale
	mpos += half_canvas
	mpos.x = floor(mpos.x)
	mpos.y = floor(mpos.y)
	return mpos

#生成
func generate_chaos_bitmap():
	for y in range(height):
		for x in range(width):
			var color = Color(rand_range(0.0, 1.0), rand_range(0.0, 1.0), rand_range(0.0, 1.0))
			set_pixel(x, y, color, false)
	emit_signal("bitmap_changed")
	take_snapshot("generate chaos image")
	
func _draw():
	for y in range(height):
		for x in range(width):
			draw_rect(Rect2(x, y, 1, 1), get_pixel(x, y))
	draw_grid()

func draw_grid():
	#画基本的外框
	draw_line(Vector2(0, 0), Vector2(width, 0), grid_color)
	draw_line(Vector2(0, height), Vector2(width, height), grid_color)
	draw_line(Vector2(0, 0), Vector2(0, height), grid_color)
	draw_line(Vector2(width, 0), Vector2(width, height), grid_color)
	#画网格
	if not show_grid: return
	for x in range(grid_size, width, grid_size):
		draw_line(Vector2(x, 0), Vector2(x, height), grid_color)
	for y in range(grid_size, height, grid_size):
		draw_line(Vector2(0, y), Vector2(width, y), grid_color)
		
func save_as_png(save_path:String = "user://save.png"):
	#简单粗暴的方法，直接套API
	var image = Image.new()
	image.create(width, height, false, Image.FORMAT_RGBA8)
	image.lock()
	for y in range(height):
		for x in range(width):
			image.set_pixel(x, y, get_pixel(x, y))
	image.unlock()
	image.save_png(save_path)
	
func open_png(open_path:String = "user://icon.png"):
	var image = Image.new()
	image.load(open_path)
	canvas_init(image.get_width(), image.get_height())
	image.lock()
	for y in range(height):
		for x in range(width):
			set_pixel(x, y, image.get_pixel(x, y), false)
	emit_signal("bitmap_changed")
	take_snapshot("open png file")
	
static func bresenham(p1:Vector2, p2:Vector2) -> PoolVector2Array:
	var set := PoolVector2Array()
	
	var steep := abs(p2.y - p1.y) > abs(p2.x - p1.x)
	if steep:
		#交换x，y坐标值
		p1 = Vector2(p1.y, p1.x)
		p2 = Vector2(p2.y, p2.x)
	if p1.x > p2.x:
		#交换p1和p2
		var tmp = p1
		p1 = p2
		p2 = tmp
		
	var deltax := int(p2.x - p1.x)
	var deltay := int(abs(p2.y - p1.y))
	var error := int(deltax / 2.0)
	var y := p1.y
	var ystep := 1 if p1.y < p2.y else -1
	for x in range(p1.x, p2.x + 1):
		set.append(Vector2(y, x) if steep else Vector2(x, y))
		error = error - deltay
		if error < 0:
			y += ystep
			error += deltax
	return set

func set_pixel_line(p0:Vector2, p1:Vector2, color:Color):
	var flag = false
	var interpolation = bresenham(p0, p1)
	for p in interpolation:
		if is_valid_pixelv(p):
			flag = true
			set_pixelv(p, color, false)
	if flag:
		emit_signal("bitmap_changed")
		take_snapshot("set line")
	
func set_pixel_filled_rect(rect:Rect2, color:Color):
	var intersaction = rect.clip(get_bitmap_rect())
	for y in range(intersaction.position.y, intersaction.end.y):
		for x in range(intersaction.position.x, intersaction.end.x):
			set_pixelv(Vector2(x, y), color, false)
	if intersaction.size.x > 0 or intersaction.size.y > 0:
		emit_signal("bitmap_changed")
		take_snapshot("set filled rect")

func set_pixel_rect(rect:Rect2, color: Color):
	var flag = false
	for x in range(rect.position.x, rect.end.x):
		if is_valid_pixel(x, rect.position.y):
			flag = true
			set_pixel(x, rect.position.y, color, false)
		if is_valid_pixel(x, rect.end.y-1):
			flag = true
			set_pixel(x, rect.end.y-1, color, false)
	for y in range(rect.position.y + 1, rect.end.y-1):
		if is_valid_pixel(rect.position.x, y):
			flag = true
			set_pixel(rect.position.x, y, color, false)
		if is_valid_pixel(rect.end.x-1, y):
			flag = true
			set_pixel(rect.end.x-1, y, color ,false)
	
	if flag:
		emit_signal("bitmap_changed")
		take_snapshot("set rect")

func set_pixels(points:PoolVector2Array, c:Color):
	var flag = false
	for p in points:
		if is_valid_pixelv(p):
			flag = true
			set_pixelv(p, c, false)
	if flag:
		emit_signal("bitmap_changed")
		take_snapshot("set pixels")

func clear():
	for i in range(width * height):
		bitmap[i] = Color.transparent
	emit_signal("bitmap_changed")
	take_snapshot("clear canvas")

#保存当前的图像到历史缓存中
func take_snapshot(msg = null):
	if not record_history: return
	#单分支历史,剪去之前的分支
	if bitmap_cache.size() != (history_pointer + 1):
		for i in range(bitmap_cache.size() - 1, history_pointer, -1):
			bitmap_cache.remove(i)
	if bitmap_cache.size() >= max_history_cache:
		bitmap_cache.remove(0)
		history_pointer -= 1
	bitmap_cache.append(bitmap)
	history_pointer += 1
	
	print("history saved at ", history_pointer, ", ", msg if msg else "")
	
#撤销，undo
func undo():
	if history_pointer <= 0: return
	history_pointer -= 1
	bitmap = bitmap_cache[history_pointer]
	emit_signal("bitmap_changed")
	print("undo ", history_pointer)

#恢复撤销，redo
func redo():
	if history_pointer+1 == bitmap_cache.size(): return
	history_pointer += 1
	bitmap = bitmap_cache[history_pointer]
	emit_signal("bitmap_changed")
	print("redo ", history_pointer)

func _on_PixelCanvas_bitmap_changed():
	update()
