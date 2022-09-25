extends KinematicBody2D

onready var nav_agent: NavigationAgent2D = $NavigationAgent2D
var velocity = Vector2.ZERO
var speed = 16 * 5

var is_active = false

func _ready():
	nav_agent.avoidance_enabled = true
	var desired_distance: float = 8
	nav_agent.path_desired_distance = desired_distance
	nav_agent.target_desired_distance = desired_distance
	nav_agent.radius = 4
	nav_agent.set_target_location(global_position)
	
	EventBus.connect("target_set", self, "_on_target_set")
	nav_agent.connect("velocity_computed", self, "_on_velocity_computed")
	nav_agent.connect("target_reached", self, "_on_target_reached")
	$PickableMapObject.connect("selected", self, "_on_selected")
	$PickableMapObject.connect("deselected", self, "_on_deselected")
	pass
	
func _on_target_reached():
	_on_deselected()
	
func _on_velocity_computed(velocity: Vector2):
	move_and_slide(velocity)

func _on_selected():
	is_active = true
	$Sprite.self_modulate = Color.aqua

func _on_deselected():
	is_active = false
	$Sprite.self_modulate = Color.white
	
func _on_target_set(target_position):
	if not is_active:
		return
	nav_agent.set_target_location(target_position)

func _physics_process(delta):
	if not nav_agent.is_navigation_finished():
		var current_pos = global_position
		var target = nav_agent.get_next_location()
		velocity = current_pos.direction_to(target) * speed
		nav_agent.set_velocity(velocity)
