extends Node2D
class_name PickableMapObject

signal selected()
signal deselected()

func _ready():
	EventBus.connect("pickable_map_selection_changed", self, "_on_selection_changed")
	pass

func _on_selection_changed(start_pos, end_pos):
	var x_range = [start_pos.x, end_pos.x]
	x_range.sort()
	var y_range = [start_pos.y, end_pos.y]
	y_range.sort()
	if global_position.x > x_range[0] and global_position.x < x_range[1] and global_position.y > y_range[0] and global_position.y < y_range[1]:
		emit_signal("selected")
	else:
		emit_signal("deselected")
