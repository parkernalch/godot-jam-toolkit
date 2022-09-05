extends Area2D

export var move_time = 0.125
export var tile_size = 16

onready var tween = $Tween
onready var cast = $RayCast2D

func _ready():
	position = position.snapped(Vector2.ONE * tile_size)
	position += Vector2.ONE * tile_size / 2
	pass
	
func _process(delta):
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
	cast.cast_to = direction * tile_size
	cast.force_raycast_update()
	if cast.is_colliding():
		tween_bump(direction, duration)
	else:
		tween_to(direction, duration)

func tween_to(direction, duration):
	tween.interpolate_property(
		self,
		"position",
		position,
		position + direction * tile_size,
		duration,
		Tween.TRANS_SINE,
		Tween.EASE_IN_OUT
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
