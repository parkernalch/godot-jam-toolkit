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

var loaded_data_resource

func _ready():
	loaded_data_resource = player_data
	preset_picker.connect("preset_loaded", self, "_on_preset_loaded")
	update_options_from_resource()

func update_options_from_resource():
	max_height.text = str(loaded_data_resource.jump_max_height)
	is_variable.pressed = loaded_data_resource.jump_is_variable
	duration.text = str(loaded_data_resource.jump_duration)
	jump_count.text = str(loaded_data_resource.jump_midair_count)
	air_control.pressed = loaded_data_resource.jump_has_air_control
	jump_buffer.text = str(loaded_data_resource.jump_buffer_timeout)
	coyote_buffer.text = str(loaded_data_resource.jump_coyote_timeout)
	EventBus.emit_signal("platformer_resource_updated", loaded_data_resource)
	pass

func _on_preset_loaded(preset_data):
	loaded_data_resource = preset_data
	update_options_from_resource()
