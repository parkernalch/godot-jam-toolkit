extends Area2D

export var move_time = 0.3
export var tile_size = 16

onready var tween = $Tween
onready var right_cast = $RightCast
onready var up_cast = $UpCast
onready var left_cast = $LeftCast
onready var down_cast = $DownCast

var input_released = false
var is_running = false

func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size / 2
	pass
	
func _process(delta):
	is_running = Input.is_action_pressed("run")
	if tween.is_active():
		return
	if Input.is_action_pressed("move_left"):
		move(Vector2.LEFT, move_time)
	if Input.is_action_pressed("move_right"):
		move(Vector2.RIGHT, move_time)
	if Input.is_action_pressed("move_up"):
		move(Vector2.UP, move_time)
	if Input.is_action_pressed("move_down"):
		move(Vector2.DOWN, move_time)
	pass
	
func _physics_process(delta):
	pass

func move(direction, duration):
	var will_bump = false
	match direction:
		Vector2.RIGHT:
			will_bump = right_cast.is_colliding()
		Vector2.UP:
			will_bump = up_cast.is_colliding()
		Vector2.LEFT:
			will_bump = left_cast.is_colliding()
		Vector2.DOWN:
			will_bump = down_cast.is_colliding()
	if will_bump:
		tween_bump(direction, duration)
	else:
		tween_to(direction, duration)

func tween_to(direction, duration):
	tween.interpolate_property(
		self,
		"position",
		position,
		position + direction * tile_size,
		duration if not is_running else duration * 0.5,
		Tween.TRANS_LINEAR
#		Tween.EASE_IN_OUT
	)
	tween.start()
	
func tween_bump(direction, duration):
	tween.interpolate_property(
		self,
		"position",
		position,
		position + direction * tile_size * 0.5,
		duration / 2,
		Tween.TRANS_SINE,
		Tween.EASE_IN
	)
	tween.interpolate_property(
		self,
		"position",
		position + direction * tile_size * 0.5,
		position,
		duration / 2,
		Tween.TRANS_SINE,
		Tween.EASE_OUT,
		duration / 2
	)
	tween.start()
