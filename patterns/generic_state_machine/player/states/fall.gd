extends State

@export var idle_state: State
@export var move_state: State
@export var jetpack_state: State

@export var air_accel: float = 7.0

var momentum: float

func enter() -> void:
	momentum = parent.velocity.x

func process_physics(delta: float) -> State:
	parent.velocity.y += parent.gravity * delta
	if Input.is_action_pressed("jetpack"):
		return jetpack_state

	var input_dir = Input.get_axis('left', 'right')
	var movement = input_dir * parent.move_speed

	# If movement input is opposite of current momentum, reduce horizontal velocity
	if (momentum * input_dir) < 0 or !momentum:
		# Add the new direction input, accounting for move speed and air accel
		parent.velocity.x += air_accel * movement * delta
		# set the new velocity to the current momentum
		momentum = parent.velocity.x
	elif parent.velocity.x != 0:
		# Carry the momentum of the player from the previous state
		parent.velocity.x = momentum

	if parent.is_on_wall():
		parent.velocity.x = 0

	parent.move_and_slide()
	
	if parent.is_on_floor():
		if movement != 0:
			return move_state
		return idle_state
	return null
