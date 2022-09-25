extends Node2D
class_name SquashStretch

var tween : Tween;

func _ready():
	tween = Tween.new()
	add_child(tween)
	pass
	
func squash(magnitude, duration):
	var start_scale = Vector2(1, 1)
	var end_scale = Vector2(scale.x + magnitude, scale.y - magnitude)
	tween.interpolate_property(
		self,
		"scale",
		start_scale,
		end_scale,
		duration / 2,
		Tween.TRANS_EXPO,
		Tween.EASE_IN_OUT
	)
	tween.interpolate_property(
		self,
		"scale",
		end_scale,
		start_scale,
		duration / 2,
		Tween.TRANS_EXPO,
		Tween.EASE_IN_OUT,
		duration / 2
	)
	tween.start()
	
func stretch(magnitude, duration):
	var start_scale = Vector2(1, 1)
	var end_scale = Vector2(scale.x - magnitude, scale.x + magnitude)
	tween.interpolate_property(
		self,
		"scale",
		start_scale,
		end_scale,
		duration / 2,
		Tween.TRANS_EXPO,
		Tween.EASE_IN_OUT
	)
	tween.interpolate_property(
		self,
		"scale",
		end_scale,
		start_scale,
		duration / 2,
		Tween.TRANS_EXPO,
		Tween.EASE_IN_OUT,
		duration / 2
	)
	tween.start()
	
func squash_and_stretch(magnitude, duration, decay=true):
	squash(magnitude, duration / 2)
	yield(get_tree().create_timer(duration / 2), "timeout")
	var second_magnitude = magnitude if not decay else magnitude * 0.5
	stretch(second_magnitude , duration / 2)
	
func stretch_and_squash(magnitude, duration, decay=true):
	stretch(magnitude * 0.5, duration / 2)
	yield(get_tree().create_timer(duration / 2), "timeout")
	var second_magnitude = magnitude if not decay else magnitude * 0.5
	squash(second_magnitude, duration / 2)
