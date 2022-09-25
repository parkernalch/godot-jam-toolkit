extends KinematicBody2D

var input_direction = Vector2.ZERO
export var tile_size = 16
export var tiles_per_second = 5

var is_running = false

func _ready():
	pass
	
func _process(_delta):
	is_running = Input.is_action_pressed("run")
	input_direction = Vector2(
		Input.get_action_raw_strength("move_right") - Input.get_action_raw_strength("move_left"),
		Input.get_action_raw_strength("move_down") - Input.get_action_raw_strength("move_up")
	)
	pass
	
func _physics_process(delta):
	var run_mod = 1 if not is_running else 2
	move_and_slide(input_direction.normalized() * tile_size * tiles_per_second * run_mod)
	pass
