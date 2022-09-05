extends PanelContainer

onready var player_data = preload("res://Resources/platformer_data.tres")
onready var preset_picker = $VBox/HeaderHSplit/PresetPicker

onready var max_height = $VBox/TabContainer/Jump/ScrollContainer/Buttons/MaxHeightInput
onready var is_variable = $VBox/TabContainer/Jump/ScrollContainer/Buttons/VariableJumpCheckbox
onready var duration = $VBox/TabContainer/Jump/ScrollContainer/Buttons/JumpDurationInput
onready var jump_count = $VBox/TabContainer/Jump/ScrollContainer/Buttons/JumpCountInput
onready var air_control = $VBox/TabContainer/Jump/ScrollContainer/Buttons/AirControlInput
onready var jump_buffer = $VBox/TabContainer/Jump/ScrollContainer/Buttons/JumpBufferInput
onready var coyote_buffer = $VBox/TabContainer/Jump/ScrollContainer/Buttons/CoyoteBufferInput

onready var acceleration = $VBox/TabContainer/Move/ScrollContainer/Buttons/AccelerationTimeInput
onready var deceleration = $VBox/TabContainer/Move/ScrollContainer/Buttons/DecelerationTimeInput
onready var top_speed = $VBox/TabContainer/Move/ScrollContainer/Buttons/TopSpeedInput

onready var gravity_up = $VBox/TabContainer/Jump/ScrollContainer/Buttons/RisingGravityInput
onready var gravity_down = $VBox/TabContainer/Jump/ScrollContainer/Buttons/FallingGravityInput
onready var terminal_velocity = $VBox/TabContainer/Jump/ScrollContainer/Buttons/TerminalVelocityInput

var loaded_data_resource: PlatformerData
var data_props: Array

func _ready():
	loaded_data_resource = player_data
	for prop in loaded_data_resource.get_property_list():
		data_props.append({ name = prop.name, type = prop.type})
	preset_picker.connect("preset_loaded", self, "_on_preset_loaded")
	connect("hide", self, "_on_dismiss")
	connect_observers()
	update_options_from_resource()

func _on_dismiss():
	EventBus.emit_signal("platformer_resource_updated", loaded_data_resource)

func connect_observers():
	max_height.connect("text_changed", self, "_on_input_changed", ["jump_max_height", max_height])
	is_variable.connect("toggled", self, "_on_checkbox_changed", ["jump_is_variable", is_variable])
	duration.connect("text_changed", self, "_on_input_changed", ["jump_duration", duration])
	jump_count.connect("text_changed", self, "_on_input_changed", ["jump_midair_count", jump_count])
	air_control.connect("toggled", self, "_on_checkbox_changed", ["jump_has_air_control", air_control])
	jump_buffer.connect("text_changed", self, "_on_input_changed", ["jump_buffer_timeout", jump_buffer])
	coyote_buffer.connect("text_changed", self, "_on_input_changed", ["jump_coyote_timeout", coyote_buffer])
	acceleration.connect("text_changed", self, "_on_input_changed", ["move_acceleration_time", acceleration])
	deceleration.connect("text_changed", self, "_on_input_changed", ["move_deceleration_time", deceleration])
	top_speed.connect("text_changed", self, "_on_input_changed", ["move_top_speed", top_speed])
	gravity_up.connect("text_changed", self, "_on_input_changed", ["gravity_up_modifier", gravity_up])
	gravity_down.connect("text_changed", self, "_on_input_changed", ["gravity_down_modifier", gravity_down])
	terminal_velocity.connect("text_changed", self, "_on_input_changed", ["gravity_terminal_velocity", top_speed])

func update_options_from_resource():
	max_height.text = str(loaded_data_resource.jump_max_height)
	is_variable.pressed = loaded_data_resource.jump_is_variable
	duration.text = str(loaded_data_resource.jump_duration)
	jump_count.text = str(loaded_data_resource.jump_midair_count)
	air_control.pressed = loaded_data_resource.jump_has_air_control
	jump_buffer.text = str(loaded_data_resource.jump_buffer_timeout)
	coyote_buffer.text = str(loaded_data_resource.jump_coyote_timeout)
	acceleration.text = str(loaded_data_resource.move_acceleration_time)
	deceleration.text = str(loaded_data_resource.move_deceleration_time)
	top_speed.text = str(loaded_data_resource.move_top_speed)
	gravity_down.text = str(loaded_data_resource.gravity_down_modifier)
	gravity_up.text = str(loaded_data_resource.gravity_up_modifier)
	terminal_velocity.text = str(loaded_data_resource.gravity_terminal_velocity)
#	EventBus.emit_signal("platformer_resource_updated", loaded_data_resource)
	pass

func _on_input_changed(new_value, param_name, caller):
	for prop in data_props:
		if prop.name != param_name:
			continue
		if prop.type == TYPE_INT and new_value.is_valid_integer():
			loaded_data_resource[param_name] = int(new_value)
		elif prop.type == TYPE_REAL and new_value.is_valid_float():
			loaded_data_resource[param_name] = float(new_value)
#		elif prop.type in [ TYPE_INT, TYPE_REAL] and new_value.length() == 0:
#			loaded_data_resource[param_name] = 0
#			caller.text = "0"
		else:
			caller.text = str(loaded_data_resource[param_name])
#	EventBus.emit_signal("platformer_resource_updated", loaded_data_resource)
	
func _on_checkbox_changed(pressed, param_name, _caller):
	for prop in data_props:
		if prop.name != param_name:
			continue
		loaded_data_resource[param_name] = pressed
#	EventBus.emit_signal("platformer_resource_updated", loaded_data_resource)

func _on_preset_loaded(preset_data):
	loaded_data_resource = preset_data
	update_options_from_resource()
