extends KinematicBody2D

onready var tile_size = 16
onready var tiles_per_second = 3

var input_direction = Vector2.ZERO

func _ready():
	pass
	
func _process(_delta):
	input_direction = Vector2(
		Input.get_action_strength("move_right") - Input.get_action_strength("move_left"),
		Input.get_action_strength("move_down") - Input.get_action_strength("move_up")
	)
	pass
	
func _physics_process(delta):
	move_and_slide(input_direction.normalized() * tile_size * tiles_per_second)
	pass
