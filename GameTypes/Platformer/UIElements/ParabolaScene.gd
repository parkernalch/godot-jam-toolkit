extends Node2D

onready var line = $Line2D
onready var path = $Path2D

var v_i = Vector2(10, -50)
var v_x = 10

export var air_time = 1.0
export var jump_height = 5.0

export var g_rising = -9.8
export var g_falling = -9.8

export var start_offset = Vector2(100, -250)

func _ready():
	v_i = Vector2(v_x, 0.5 * g_rising)
	
	var points = []
	for i in range(100):
		var pt = compute_at_t(i/100)
		points.append(pt * 100)
		if pt.y > start_offset.y:
			break
	line.points = points
	print(points.size())
	
func compute_at_t(time):
	var t = start_offset.x + v_i.x * time
	var f_t = start_offset.y + v_i.y * time + 0.5 * 9.8 * pow(time, 2)
	return Vector2(t, f_t)
