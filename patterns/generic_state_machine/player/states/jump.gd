extends State

@export var fall_state: State
@export var idle_state: State
@export var move_state: State

@export var jump_force: float = 100.0
@export var jump_timer_max : float = 0.1
@export var jump_boost: float = 1.5
@export var air_accel: float = 10.0

var momentum: float
var jump_timer : float


func enter() -> void:
	super()
	momentum = parent.velocity.x
	parent.velocity.y = -jump_force
	jump_timer = 0.0

func process_physics(delta: float) -> State:
	jump_timer += delta

	# Add variable jump height when jump is held 
	if Input.is_action_pressed("ui_accept") and jump_timer < jump_timer_max:
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
		jump_timer = 0.0
		if movement != 0:
			return move_state
		return idle_state
	
	return null
