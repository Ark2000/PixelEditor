extends Node2D

signal bitmap_changed
signal bitmap_init

var file_name = "unnamed"
var palette_name = "default16"
const canvas_scale = 8
const grid_color = Color.cyan
var show_grid := false
var grid_size := Vector2(4, 4)
var grid_offset := Vector2(0, 0)
var bg_color := Color.transparent

var bitmap: PoolColorArray
var width := 0
var height := 0

var recorder := CanvasHistoryRecorder.new()

func _ready():
	scale = Vector2(canvas_scale, canvas_scale)

#初始化画布，分配内存
func canvas_init(w: int, h: int, clear_history=true, centered=true):
	self.width = w
	self.height = h
	bitmap = PoolColorArray([])
	for _i in range(width * height):
		bitmap.push_back(Color(0.0, 0.0, 0.0, 0.0))
	emit_signal("bitmap_changed")
	#居中摆放画布
	if centered:
		position = Vector2(-width, -height) * canvas_scale / 2
	emit_signal("bitmap_init", Vector2(w, h), position)
	
	if clear_history:
		recorder.clear()

#检查越界
func is_valid_pixel(x, y) -> bool:
	if x < 0 or x >= width or y < 0 or y >= height:
		return false
	return true
func is_valid_pixelv(p:Vector2) -> bool:
	return is_valid_pixel(int(p.x), int(p.y))
	
func get_bitmap_copy() -> PoolColorArray:
	return bitmap
	
func set_bitmap(m:PoolColorArray):
	bitmap = m
	emit_signal("bitmap_changed")

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
func get_bitmap_rect() -> Rect2:
	var rect = Rect2()
	rect.position = Vector2(0, 0)
	rect.size = Vector2(width, height)
	return rect
func set_file_name(s:String):
	file_name = s
func set_bg_color(c:Color):
	bg_color = c
	emit_signal("bitmap_changed")
	
func switch_grid_display():
	show_grid = !show_grid
	emit_signal("bitmap_changed")
	
func set_show_grid(val):
	if val != show_grid:
		emit_signal("bitmap_changed")
	show_grid = val
	
func set_grid_size(val):
	if val != grid_size:
		emit_signal("bitmap_changed")
	grid_size = val
	
func set_grid_offset(val):
	if val != grid_offset:
		emit_signal("bitmap_changed")
	grid_offset = val

#将传入的全局坐标转化为位图坐标
func global_to_canvas_position(var mpos:Vector2) -> Vector2:
	var cp = mpos - position
	cp.x = int(cp.x / canvas_scale)
	cp.y = int(cp.y / canvas_scale)
	return cp

#生成
func generate_chaos_bitmap():
	for y in range(height):
		for x in range(width):
			var color = Color(rand_range(0.0, 1.0), rand_range(0.0, 1.0), rand_range(0.0, 1.0))
			set_pixel(x, y, color, false)
	emit_signal("bitmap_changed")
	
func _draw():
	draw_rect(get_bitmap_rect(), bg_color)
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
	for x in range(grid_offset.x, width, grid_size.x):
		draw_line(Vector2(x, 0), Vector2(x, height), grid_color)
	for y in range(grid_offset.y, height, grid_size.y):
		draw_line(Vector2(0, y), Vector2(width, y), grid_color)

func save_as_png(img_scale = 1):
	#简单粗暴的方法，直接套API
	var image = Image.new()
	image.create(width * img_scale, height * img_scale, false, Image.FORMAT_RGBA8)
	image.lock()
	for y in range(height * img_scale):
		for x in range(width * img_scale):
			image.set_pixel(x, y, get_pixel(x / img_scale, y / img_scale))
	image.unlock()
	
	image.save_png(Globals.USERART_SAVE_FOLDER + file_name + ".png")
	
func open_png(open_path:String = "user://icon.png"):
	var image = Image.new()
	image.load(open_path)
	canvas_init(image.get_width(), image.get_height())
	image.lock()
	for y in range(height):
		for x in range(width):
			set_pixel(x, y, image.get_pixel(x, y), false)
	emit_signal("bitmap_changed")
	
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

#返回值代表画布是否发生改变
func set_pixel_line(p0:Vector2, p1:Vector2, color:Color) -> bool:
	var flag = false
	var interpolation = bresenham(p0, p1)
	for p in interpolation:
		if is_valid_pixelv(p):
			flag = true
			set_pixelv(p, color, false)
	if flag:
		emit_signal("bitmap_changed")
		return true
	return false
	
func set_pixel_filled_rect(rect:Rect2, color:Color) -> bool:
	var intersaction = rect.clip(get_bitmap_rect())
	for y in range(intersaction.position.y, intersaction.end.y):
		for x in range(intersaction.position.x, intersaction.end.x):
			set_pixelv(Vector2(x, y), color, false)
	if intersaction.size.x > 0 or intersaction.size.y > 0:
		emit_signal("bitmap_changed")
		return true
	return false

func set_pixel_rect(rect:Rect2, color: Color) -> bool:
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
		return true
	return false

func set_pixels(points:PoolVector2Array, c:Color) -> bool:
	var flag = false
	for p in points:
		if is_valid_pixelv(p):
			flag = true
			set_pixelv(p, c, false)
	if flag:
		emit_signal("bitmap_changed")
		return true
	return false

#像素填充算法（虽然解决了stackoverflow的问题，但运行速度还是很慢，是一个优化点）
const _adjs = [Vector2(-1, 0), Vector2(1, 0), Vector2(0, 1), Vector2(0, -1)]
func flood_fill(p:Vector2, c: Color):
	var orignal
	var candidates = PoolVector2Array()
	if is_valid_pixelv(p):
		orignal = get_pixelv(p)
	else:
		return false
	if orignal == c:
		return false
	candidates.append(p)
	while not candidates.empty():
		var can = candidates[0]
		candidates.remove(0)
		if is_valid_pixelv(can) and get_pixelv(can) == orignal:
			set_pixelv(can, c, false)
			for a in _adjs:
				if is_valid_pixelv(can + a) and get_pixelv(can + a) == orignal: 
					candidates.push_back(can + a)
	emit_signal("bitmap_changed")
	return true
	
#整体偏移
func overall_shift(offset:Vector2):
	if offset == Vector2.ZERO: return false
	var r1
	var r2
	if offset.x > 0:
		r1 = range(width - offset.x - 1, -1, -1)
		r2 = range(offset.x)
	else:
		r1 = range(-offset.x, width)
		r2 = range(width + offset.x, width)
	for y in range(height):
		for x in r1:
			set_pixel(x + offset.x, y, get_pixel(x, y), false)
		for x in r2:
			set_pixel(x, y, Color.transparent, false)
	if offset.y > 0:
		r1 = range(height - offset.y - 1, -1, -1)
		r2 = range(offset.y)
	else:
		r1 = range(-offset.y, height)
		r2 = range(height + offset.y, height)
	for x in range(width):
		for y in r1:
			set_pixel(x, y + offset.y, get_pixel(x, y), false)
		for y in r2:
			set_pixel(x, y, Color.transparent, false)
	emit_signal("bitmap_changed")
	return true

#改变画布的尺寸
#具体的规则比较绕，拿行来举例。比如原H=32,现H=17,就代表要保留17行，那么Y的取值为[0, 15)
#Y代表从哪一行（尺寸改变前）开始复制。如果原H=32,现H=37，那么就代表要扩增5行，Y的取值为[0, 5)，代表从哪一行（尺寸改变后）开始复制。复制：for y in range(min(OH, CH)):
# if OH > CH: O[y + CY] -> C[y] else: O[y] -> C[y + CY]
func canvas_clip(cur:Rect2, centered=true):
	assert(cur.position.x <= abs(width - cur.size.x))
	assert(cur.position.y <= abs(height - cur.size.y))
	if cur == get_bitmap_rect(): return false
	var tmp = get_bitmap_copy() #original bitmap data
	var osize = get_bitmap_size() # original bitmap size
	#we handle rows first
	canvas_init(int(width), int(cur.size.y), false, centered)
	for y in range(min(height, osize.y)):
		for x in range(width):
			if osize.y > height: #shrink
				set_pixel(x, y, tmp[x + (y + cur.position.y) * osize.x], false)
			else: #extend
				set_pixel(x, y + cur.position.y, tmp[x + y * osize.x], false)
	#now we handle colums
	tmp = get_bitmap_copy()
	canvas_init(int(cur.size.x), int(height), false, centered)
	for x in range(min(width, osize.x)):
		for y in range(height):
			if osize.x > width: #shrink
				set_pixel(x, y, tmp[x + cur.position.x + y * osize.x], false)
			else:#extend
				set_pixel(x + cur.position.x, y, tmp[x + y * osize.x], false)
	emit_signal("bitmap_changed")

func clear(sgl= true):
	for i in range(width * height):
		bitmap[i] = Color(0.0, 0.0, 0.0, 0.0)
	if sgl:
		emit_signal("bitmap_changed")
	
func restore_memento(memento):
	canvas_init(memento.width, memento.height, false)
	bitmap = memento.bitmap
	emit_signal("bitmap_changed")
	
func create_memento():
	var memento = CanvasMemento.new()
	memento.set_state(get_bitmap_copy(), width, height)
	return memento
	
func record(msg=""):
	recorder.record(create_memento())
	Logger.Log("New memento", LogEntry.GENERIC, msg)
	
func undo():
	if recorder.has_previous():
		restore_memento(recorder.get_previous())
		Logger.Log("Undo", LogEntry.GENERIC, String(recorder.history_pointer))

func redo():
	if recorder.has_next():
		restore_memento(recorder.get_next())
		Logger.Log("Redo", LogEntry.GENERIC, String(recorder.history_pointer))

func _on_PixelCanvas_bitmap_changed():
	update()
