extends KinematicBody2D

export var move_tiles_per_second = 5
export var move_time = 0.5

func _ready():
	pass
	
func _process(delta):
	if Input.is_action_just_pressed("move_left"):
		move(Vector2(-1, 0), move_time)
	if Input.is_action_just_pressed("move_right"):
		move(Vector2(1, 0), move_time)
	if Input.is_action_just_pressed("move_up"):
		move(Vector2(0, -1), move_time)
	if Input.is_action_just_pressed("move_down"):
		move(Vector2(0, 1), move_time)
	pass
	
func _physics_process(delta):
	pass

func move(direction, duration):
	pass
