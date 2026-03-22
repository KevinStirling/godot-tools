class_name Inventory
extends Node2D

@export var grid_size: Vector2 = Vector2(5,5)
@export var cell_size: Vector2 = Vector2(128,128)

func _draw() -> void:
	for row in range(grid_size.y + 1):
		draw_line(Vector2(0, cell_size.y * row), Vector2(cell_size.x * grid_size.x, cell_size.x * row),Color.ALICE_BLUE, 2.0, false)
	for col in range(grid_size.x + 1):
		draw_line(Vector2(cell_size.x * col, 0), Vector2(cell_size.x * col, cell_size.y * grid_size.y), Color.ALICE_BLUE, 2.0, false)

func in_bounds(position: Vector2) -> bool:
	var origin = global_position
	var max_bounds = grid_size * cell_size
	if position < origin || position > max_bounds:
		return false
	return true
