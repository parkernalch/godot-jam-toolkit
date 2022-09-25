tool
extends Resource
class_name PlatformerData

# HMovement
var move_acceleration_time: float = 1.0
var move_deceleration_time: float = 1.0
var move_top_speed: float = 10.0

# VMovement
var jump_max_height: float = 5.5
var jump_is_variable: bool = true
var jump_duration: float = 1.0
var jump_midair_count: int = 1
var jump_has_air_control: bool = true
var jump_buffer_timeout: float = 0.0
var jump_coyote_timeout: float = 0.0

# Wall Jumping
var wall_drag = 0.5
var wall_drag_decay_time = 5.0
var wall_jump_enabled = true
var wall_jump_force = 10.0
var wall_jump_angle = 45.0
var wall_jump_control_timeout = 0.3

# Gravity
var gravity_up_modifier: float = 5
var gravity_down_modifier: float = 5
var gravity_terminal_velocity: float = 10

func _get_property_list():
	var properties = []
	properties.append({
		name = "Gravity",
		type = TYPE_NIL,
		hint_string = "gravity_",
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
	})	
	properties.append({
		name = "gravity_up_modifier",
		type = TYPE_REAL
	})
	properties.append({
		name = "gravity_down_modifier",
		type = TYPE_REAL
	})
	properties.append({
		name = "gravity_terminal_velocity",
		type = TYPE_REAL
	})
	
	properties.append({
		name = "Jump",
		type = TYPE_NIL,
		hint_string = "jump_",
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	properties.append({
		name = "jump_max_height",
		type = TYPE_REAL
	})
	properties.append({
		name = "jump_is_variable",
		type = TYPE_BOOL
	})
	properties.append({
		name = "jump_duration",
		type = TYPE_REAL
	})
	properties.append({
		name = "jump_midair_count",
		type = TYPE_INT
	})
	properties.append({
		name = "jump_has_air_control",
		type = TYPE_BOOL
	})
	properties.append({
		name = "jump_buffer_timeout",
		type = TYPE_REAL
	})
	properties.append({
		name = "jump_coyote_timeout",
		type = TYPE_REAL
	})
	
	properties.append({
		name = "Wall Jump",
		type = TYPE_NIL,
		hint_string = "wall_",
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	properties.append({
		name = "wall_drag",
		type = TYPE_REAL
	})
	properties.append({
		name = "wall_drag_decay_time",
		type = TYPE_REAL
	})
	properties.append({
		name = "wall_jump_enabled",
		type = TYPE_BOOL
	})
	properties.append({
		name = "wall_jump_force",
		type = TYPE_REAL
	})
	properties.append({
		name = "wall_jump_angle",
		type = TYPE_REAL
	})
	properties.append({
		name = "wall_jump_control_timeout",
		type = TYPE_REAL
	})
	
	properties.append({
		name = "Movement",
		type = TYPE_NIL,
		hint_string = "move_",
		usage = PROPERTY_USAGE_GROUP | PROPERTY_USAGE_SCRIPT_VARIABLE
	})
	properties.append({
		name = "move_acceleration_time",
		type = TYPE_REAL
	})
	properties.append({
		name = "move_deceleration_time",
		type = TYPE_REAL
	})
	properties.append({
		name = "move_top_speed",
		type = TYPE_REAL
	})
	return properties
