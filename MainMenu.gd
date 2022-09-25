extends Panel

var platformer_scene = load("res://GameTypes/Platformer/platformer_scene.tscn")
var top_down_scene = load("res://GameTypes/TopDown/top_down_scene.tscn")
var isometric_scene = load("res://GameTypes/Isometric/isometric_scene.tscn")

onready var platformer_button = $VBoxContainer/HBoxContainer/VBoxContainer/PlatformerButton
onready var top_down_button = $VBoxContainer/HBoxContainer/VBoxContainer/TopDownButton
onready var isometric_button = $VBoxContainer/HBoxContainer/VBoxContainer/IsometricButton

func _ready():
	platformer_button.connect("pressed", self, "_on_button_pressed", [ "platformer"])
	top_down_button.connect("pressed", self, "_on_button_pressed", [ "top_down"])
	isometric_button.connect("pressed", self, "_on_button_pressed", [ "isometric"])
	pass
	
func _on_button_pressed(scene):
	match scene:
		"platformer":
			get_tree().change_scene_to(platformer_scene)
		"top_down":
			get_tree().change_scene_to(top_down_scene)
		"isometric":
			get_tree().change_scene_to(isometric_scene)
