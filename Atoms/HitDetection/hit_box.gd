extends Area2D
class_name HitBox

var is_active = false

func _ready():
	pass
	
func activate():
	is_active = true
	pass
	
func deactivate():
	is_active = false
	pass
