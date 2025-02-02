extends Node

signal debug_enable
signal debug_disable

var debug_view: bool = false

func _ready() -> void:
	Console.add_command("debug", toggle_debug)

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("toggle_console"):
		Console.toggle_console()

func toggle_debug():
	if debug_view:
		debug_disable.emit()
		debug_view = !debug_view
		set_collision_shapes_visible(debug_view)
	else:
		debug_enable.emit()
		debug_view = !debug_view
		set_collision_shapes_visible(debug_view)


func set_collision_shapes_visible(visible: bool):
	for node in get_tree().get_nodes_in_group("collision_shapes"):
		if node is CollisionShape2D:
			node.visible = visible
