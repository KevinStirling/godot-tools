extends State

@export var fall_state: State
@export var idle_state: State
@export var move_state: State

@export var jump_force: float = 100.0
@export var jetpack_timer_max: float = 5.0
@export var jump_boost: float = 1.5
@export var air_accel: float = 100.0

var momentum: float
var jetpack_timer : float

func enter() -> void:
	super()
	momentum = parent.velocity.x
	parent.velocity.y = -jump_force
	jetpack_timer = 0.0

func process_physics(delta: float) -> State:
	jetpack_timer += delta

	# add upward velocity when jetpack is active
	if Input.is_action_pressed("jetpack") and jetpack_timer < jetpack_timer_max:
		parent.velocity.y += parent.JUMP_VELOCITY
	else:
		parent.velocity.y += gravity * delta
	
	if parent.velocity.y > 0:
		return fall_state
	
	var input_dir = Input.get_axis('left', 'right') 
	var movement = input_dir * move_speed
	
	if ( parent.velocity.x * input_dir < 0 ):
		parent.velocity.x += air_accel * input_dir * delta
	else: 
		parent.velocity.x += movement * jump_boost * delta

	if parent.is_on_wall():
		parent.velocity.x = 0

	parent.move_and_slide()
	
	if parent.is_on_floor():
		jetpack_timer = 0.0
		if movement != 0:
			return move_state
		return idle_state
	
	return null
