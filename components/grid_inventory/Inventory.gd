class_name Inventory
extends Node2D

@export var grid_size: Vector2 = Vector2(5,5)
@export var cell_size: Vector2 = Vector2(128,128)

func _draw() -> void:
	# draw the grid based on grid_size & cell_size
	for row in range(grid_size.y + 1):
		draw_line(Vector2(0, cell_size.y * row), Vector2(cell_size.x * grid_size.x, cell_size.x * row),Color.ALICE_BLUE, 2.0, false)
	for col in range(grid_size.x + 1):
		draw_line(Vector2(cell_size.x * col, 0), Vector2(cell_size.x * col, cell_size.y * grid_size.y), Color.ALICE_BLUE, 2.0, false)

## checks if a position is in bounds of the grid, and accounts for the area of the item at that position
func in_bounds(position: Vector2, area: Vector2) -> bool:
	var origin = global_position
	var max_bounds = grid_size * cell_size
	var max_pos = position + area

	if is_less_vec(position, origin) || is_greater_vec(max_pos, max_bounds):
		return false
	return true

## checks if a.x or a.y is greater than b.x or b.y
func is_greater_vec(a: Vector2, b: Vector2) -> bool:
	if a.x > b.x || a.y > b.y:
		return true
	return false

## checks if a.x or a.y is less than b.x or b.y
func is_less_vec(a: Vector2, b: Vector2) -> bool:
	if a.x < b.x || a.y < b.y:
		return true
	return false
