extends KinematicBody2D

signal movement_started(movement_direction)
signal changing_direction(current_velocity, input_direction)
signal jumped(is_grounded)
signal landed(impact_velocity)

onready var cast: RayCast2D = $DownCast
onready var coyote_timer: Timer = $CoyoteTimer
onready var jump_buffer_timer: Timer = $JumpBufferTimer

export var size_per_unit = 16

export var platformer_data : Resource
var data : PlatformerData

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
var jumps_remaining
var jump_force = 0
var jump_pressed = false
var jump_released = false

class Accel:
	var acceleration: float
	var deceleration: float
	func _init(a, d):
		self.acceleration = a
		self.deceleration = d

func _ready():
	assert(platformer_data is PlatformerData)
	data = platformer_data
	EventBus.connect("platformer_resource_updated", self, "_on_resource_updated")
	coyote_timer.connect("timeout", self, "_on_coyote_time_expired")
	set_resource_derived_properties()

func _on_coyote_time_expired():
	if jumps_remaining > 0:
		jumps_remaining -= 1

func _on_resource_updated(resource):
	print("got resource updated: " + str(resource))
	data = resource
	set_resource_derived_properties()
	
func set_resource_derived_properties():
	# scale top speed to unit size (resolution)
	top_speed = data.move_top_speed * size_per_unit
	# calculate jump force (v_0) to match max jump height
	var height = data.jump_max_height * size_per_unit
	var g_up = data.gravity_up_modifier * base_gravity * size_per_unit
	jump_force = sqrt(2 * g_up * height)
	grounded_forces = precalculateAcceleration(
		data.move_acceleration_time,
		data.move_deceleration_time
	)
	airborne_forces = grounded_forces
	if data.jump_has_air_control:
		airborne_forces = precalculateAcceleration(0.4, 0.4)
	coyote_timer.wait_time = data.jump_coyote_timeout
	coyote_timer.one_shot = true
	jump_buffer_timer.wait_time = data.jump_buffer_timeout
	jump_buffer_timer.one_shot = true
	pass

func precalculateAcceleration(accel_time, decel_time):
	# calculate acceleration required to reach full speed in t_to_speed
	var acceleration = 2 * top_speed / pow(accel_time , 2)
	# calculate deceleration required to reach full stop in t_to_stop
	var deceleration = 2 * top_speed * decel_time / pow(decel_time, 2)
	return Accel.new(acceleration, deceleration)

func _process(delta):
	horizontal_input = Input.get_action_strength("move_right") - Input.get_action_strength("move_left")		
	jump_pressed = Input.is_action_just_pressed("jump")
	if jump_pressed:
		jump_buffer_timer.start(data.jump_buffer_timeout)
	jump_released = Input.is_action_just_released("jump")
	pass
	
func apply_horizontal_forces(delta, forces):
	var isNearTopSpeed = abs(velocity.x) >= top_speed * 0.95
	if abs(horizontal_input) == 0:
		# prevents float at slow speeds
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
	if not was_airborne and not is_grounded:
		coyote_timer.start(data.jump_coyote_timeout)

	if is_grounded:
		jumps_remaining = 1 + data.jump_midair_count	
		velocity.x = apply_horizontal_forces(delta, grounded_forces)
	else:
		velocity.x = apply_horizontal_forces(delta, airborne_forces)
	
	if (jump_pressed or jump_buffer_timer.time_left > 0) and jumps_remaining > 0:
		velocity.y = - jump_force
		emit_signal("jumped", is_grounded)
		jump_pressed = false
		jumps_remaining -= 1
		jump_buffer_timer.stop()
	if data.jump_is_variable && jump_released && velocity.y < 0:
		velocity.y *= 0.2
		jump_released = false	
	
	if velocity.y > 0:
		velocity.y += base_gravity * data.gravity_down_modifier * delta * size_per_unit
	else:
		velocity.y += base_gravity * data.gravity_up_modifier * delta * size_per_unit
		
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
