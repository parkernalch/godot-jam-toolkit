extends KinematicBody2D

signal movement_started(movement_direction)
signal changing_direction(current_velocity, input_direction)
signal jumped(is_grounded)
signal landed(impact_velocity)

onready var cast = $DownCast
onready var coyote_timer = $CoyoteTimer
onready var jump_buffer_timer = $JumpBufferTimer

export var size_per_unit = 16

export var platformer_data : Resource

# Forces
var grounded_forces
var airborne_forces
var base_gravity = 9.8
# Movement
var cached_velocity = Vector2.ZERO
var velocity = Vector2.ZERO
var top_speed
var horizontal_input = 0
var time_since_last_move = 0

# Jump
var is_grounded
var jumpsRemaining
var jumpForce = 0
var jumpPressed = false
var jumpReleased = false
var time_since_jump_pressed = 0
var time_since_grounded = 0

class Accel:
	var acceleration: float
	var deceleration: float
	func _init(a, d):
		self.acceleration = a
		self.deceleration = d

func _ready():
	assert(platformer_data is PlatformerData)
	EventBus.connect("platformer_resource_updated", self, "_on_resource_updated")
	# scale top speed to unit size (resolution)
	top_speed = platformer_data.move_top_speed * size_per_unit
	# calculate jump force (v_0) to match max jump height
	var height = platformer_data.jump_max_height * size_per_unit
	var g_up = platformer_data.gravity_up_modifier * base_gravity * size_per_unit
	jumpForce = sqrt(2 * g_up * height)
	grounded_forces = precalculateAcceleration(
		platformer_data.move_acceleration_time,
		platformer_data.move_deceleration_time
	)
	airborne_forces = grounded_forces
	if platformer_data.jump_has_air_control:
		airborne_forces = precalculateAcceleration(0.4, 0.4)
	coyote_timer.wait_time = platformer_data.jump_coyote_timeout
	jump_buffer_timer.wait_time = platformer_data.jump_buffer_timeout

func _on_resource_updated(resource):
	print("got resource updated: " + str(resource))

func precalculateAcceleration(accel_time, decel_time):
	# calculate acceleration required to reach full speed in t_to_speed
	var acceleration = 2 * top_speed / pow(accel_time , 2)
	# calculate deceleration required to reach full stop in t_to_stop
	var deceleration = 2 * top_speed * decel_time / pow(decel_time, 2)
	return Accel.new(acceleration, deceleration)

func _process(delta):
	horizontal_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")		
	jumpPressed = Input.is_action_just_pressed("jump")
	jumpReleased = Input.is_action_just_released("jump")
	pass
	
func apply_horizontal_forces(delta, forces):
	var isNearTopSpeed = abs(velocity.x) >= top_speed * 0.95
	if abs(horizontal_input) == 0:
		# prevents jitter at slow speeds
		if abs(velocity.x) < top_speed * 0.1:
			return 0
		# apply deceleration
		return velocity.x + sign(velocity.x) * -1 * forces.deceleration * delta
	else:
		var v = velocity.x + forces.acceleration * delta * horizontal_input
		if isNearTopSpeed:
			# allows for quick turnraound at top speeds
			return top_speed * sign(horizontal_input)
		# apply acceleration
		return v
	return velocity.x
	
func _physics_process(delta):
	var was_airborne = not is_grounded
	var was_stationary = time_since_last_move > 0.5 and is_grounded
	is_grounded = cast.is_colliding()
	
	if was_airborne and is_grounded:
		emit_signal("landed", cached_velocity)

	if is_grounded:
		jumpsRemaining = 1 + platformer_data.jump_midair_count	
		velocity.x = apply_horizontal_forces(delta, grounded_forces)
	else:
		velocity.x = apply_horizontal_forces(delta, airborne_forces)
	
	if jumpPressed and jumpsRemaining > 0:
		velocity.y = - jumpForce
		emit_signal("jumped", is_grounded)
		jumpPressed = false
		jumpsRemaining -= 1
	if platformer_data.jump_is_variable && jumpReleased && velocity.y < 0:
		velocity.y *= 0.2
		jumpReleased = false	
	
	if velocity.y > 0:
		velocity.y += base_gravity * platformer_data.gravity_down_modifier * delta * size_per_unit
	else:
		velocity.y += base_gravity * platformer_data.gravity_up_modifier * delta * size_per_unit
		
	velocity = move_and_slide_with_snap(
		velocity, 
		Vector2.UP, 
		Vector2.UP, 
		true
	)
	cached_velocity = velocity
	
	if was_stationary and velocity.x != 0:
		emit_signal("movement_started", velocity)
	if is_grounded and velocity.x * horizontal_input < 0:
		emit_signal("changing_direction", velocity, horizontal_input)
	
	if velocity == Vector2.ZERO:
		time_since_last_move += delta
	else:
		time_since_last_move = 0
