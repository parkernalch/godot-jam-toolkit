extends Node2D

onready var param_canvas = $CanvasLayer

func _process(delta):
	if Input.is_action_just_pressed("open_menu"):
		param_canvas.visible = not param_canvas.visible
	
