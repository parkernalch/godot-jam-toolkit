extends ColorRect
class_name HealthBar

onready var tween: Tween = $Tween

export var bar_color: Color = Color.darkgray
export var bar_gradient: GradientTexture
export var buffer_color: Color = Color.white
export var buffer_lag_time: float = 1.0

var fill = 1.0

enum ORIENTATION {
	HORIZONTAL,
	VERTICAL
}
export(ORIENTATION) var orientation

func _ready():
	material.set_shader_param("color_gradient", bar_gradient)
	material.set_shader_param("unfilled_color", bar_color)
	material.set_shader_param("buffer_color", buffer_color)
	material.set_shader_param("is_horizontal", orientation == ORIENTATION.HORIZONTAL)
	material.set_shader_param("buffer_fill", fill)
	material.set_shader_param("bar_fill", fill)
	pass

func damage(amount):
	if fill == 0.0:
		return
	tween.remove_all()
	var previous_fill = fill
	if tween.is_active():
		previous_fill = material.get_shader_param("bar_fill")
	fill = max(fill - amount, 0)
	material.set_shader_param("buffer_fill", fill)
	tween.interpolate_property(
		material,
		"shader_param/bar_fill",
		previous_fill,
		fill,
		buffer_lag_time,
		Tween.TRANS_SINE,
		Tween.EASE_OUT
		)
	tween.start()
	return fill
	
func heal(amount):
	if fill == 1.0:
		return
	tween.remove_all()
	var previous_fill = fill
	if tween.is_active():
		previous_fill = material.get_shader_param("bar_fill")
	fill = min(fill + amount, 1.0)
	material.set_shader_param("bar_fill", fill)
	tween.interpolate_property(
		material,
		"shader_param/buffer_fill",
		previous_fill,
		fill,
		buffer_lag_time,
		Tween.TRANS_SINE,
		Tween.EASE_OUT
		)
	tween.start()
	return fill
