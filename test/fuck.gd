extends Node2D

func _ready():
#	print(bresenham(Vector2(0, 0), Vector2(9, 10)))
#	print(bresenham(Vector2(0, 0), Vector2(10, 10)))
#	print(bresenham(Vector2(0, 0), Vector2(10, 9)))
#	print(bresenham(Vector2(0, 0), Vector2(-9, 10)))
#	print(bresenham(Vector2(0, 0), Vector2(9, -10)))
#	print(bresenham(Vector2(0, 0), Vector2(-9, -10)))
	var a = Pencil.new()
	a.paint_tool_update()

#bresenham直线算法
func bresenham(p1:Vector2, p2:Vector2) -> PoolVector2Array:
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
