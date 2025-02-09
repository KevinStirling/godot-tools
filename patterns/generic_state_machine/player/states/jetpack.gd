extends State

@export var fall_state: State
@export var idle_state: State
@export var move_state: State

@export var jump_force: float = 100.0
@export var jetpack_timer_max: float = 5.0
@export var jump_boost: float = 1.5
@export var air_accel: float = 100.0
@export var jetpack_velocity: float = -50.0
@export var max_air_speed: Vector2 = Vector2(500.0, -500.0)

var momentum: Vector2
var jetpack_timer : float

func enter() -> void:
	super()
	momentum = parent.velocity
	parent.velocity.y += -jump_force
	jetpack_timer = 0.0

func process_physics(delta: float) -> State:
	jetpack_timer += delta

	# add upward velocity when jetpack is active
	if Input.is_action_pressed("jetpack") and jetpack_timer < jetpack_timer_max:
		# cap the verical velo
		if parent.velocity.y < max_air_speed.y:
			parent.velocity.y = max_air_speed.y
		else:
			parent.velocity.y += jetpack_velocity
	else:
		parent.velocity.y += parent.gravity * delta
	
	if parent.velocity.y > 0 and !Input.is_action_pressed("jetpack"):
		return fall_state
	
	var input_dir = Input.get_axis('left', 'right') 
	var movement = input_dir * air_accel
	
	if ( parent.velocity.x * input_dir < 0 ):
		parent.velocity.x += air_accel * input_dir * delta
	else: 
		parent.velocity.x += movement * delta

	# cap the horizonal velo
	if abs(parent.velocity.x) > max_air_speed.x:
		parent.velocity.x = input_dir * max_air_speed.x

	if parent.is_on_wall():
		parent.velocity.x = 0

	parent.move_and_slide()
	
	if parent.is_on_floor():
		jetpack_timer = 0.0
		if movement != 0:
			return move_state
		return idle_state
	
	return null
