extends Node
# if this is a node, it will have absolute positioning
# if this is a node2d, it will have its position tied to parent

@export var starting_state: State
@export var current_state: State

var parent: Player
var player_velo: Vector2 = Vector2.ZERO
var world_pos: Vector2 = Vector2.ZERO

# Initialize the state machine by giving each child state a reference to the
# parent object it belongs to and enter the default starting_state.
func init(p: Player) -> void:
	parent = p
	for child in get_children():
		if child is State:
			child.parent = p

	change_state(starting_state)

func change_state(new_state: State) -> void:
	if current_state:
		current_state.exit()

	current_state = new_state
	current_state.enter()

func process_physics(delta: float) -> void:
	var new_state = current_state.process_physics(delta)
	if new_state:
		change_state(new_state)
	player_velo = parent.velocity
	world_pos = parent.position
	
func process_input(event: InputEvent) -> void:
	var new_state = current_state.process_input(event)
	if new_state:
		change_state(new_state)

func process_frame(delta: float) -> void:
	var new_state = current_state.process_frame(delta)
	if new_state:
		change_state(new_state)
