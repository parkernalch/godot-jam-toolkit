extends Area2D
class_name HurtBox

signal got_hit(source)

func _ready():
	activate()
	
func _on_area_entered(area):
	if area == null or not area.is_active:
		return
	emit_signal("got_hit", area)
	
func activate():
	connect("area_entered", self, "_on_area_entered")
	pass
	
func deactivate():
	disconnect("area_entered", self, "_on_area_entered")
	pass
