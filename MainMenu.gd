extends Panel

var platformer_scene = load("res://GameTypes/Platformer/PlatformerScene.tscn")
onready var platformer_button = $VBoxContainer/HBoxContainer/VBoxContainer/PlatformerButton
onready var top_down_button = $VBoxContainer/HBoxContainer/VBoxContainer/TopDownButton
onready var isometric_button = $VBoxContainer/HBoxContainer/VBoxContainer/IsometricButton

func _ready():
	platformer_button.connect("pressed", self, "_on_button_pressed", [ "platformer"])
	pass
	
func _on_button_pressed(scene):
	if scene == "platformer":
		get_tree().change_scene_to(platformer_scene)
