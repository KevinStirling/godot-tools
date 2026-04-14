@tool
class_name Item
extends Node2D

@export var handle: Button

var dragging: bool = false
var offset: Vector2 = Vector2.ZERO
var _overlapping_count: int = 0
var colliding: bool:
	get:
		return _overlapping_count > 0
var rotated: bool
var last_grid_coords: Array

@export var item_sprite: Texture2D:
	set(value):
		item_sprite = value
		if %Sprite:
			%Sprite.texture = value
@export var item_sprite_size: Vector2 = Vector2(128,128)
## Shrinks collision shape inward by this many pixels per side, making it easier to place items in tight gaps
@export var collision_margin: float = 32.0
@export var collision_shape: Shape2D:
	set(value):
		collision_shape = value
		if !is_node_ready():
			await ready
		## set the collision shape to match the item, shrunk by the margin
		var col_node = get_node("Sprite/Area2D/CollisionShape2D")
		col_node.position = -item_sprite_size / 2
		var shrunk = value.duplicate()
		if shrunk is RectangleShape2D:
			shrunk.size -= Vector2(collision_margin * 2, collision_margin * 2)
		elif shrunk is ConvexPolygonShape2D:
			var points = shrunk.points
			var centroid = Vector2.ZERO
			for p in points:
				centroid += p
			centroid /= points.size()
			for i in points.size():
				var dir = (points[i] - centroid).normalized()
				points[i] -= dir * collision_margin
			shrunk.points = points
		col_node.shape = shrunk

func _ready() -> void:
	handle.size = item_sprite_size
	handle.position = -item_sprite_size * .5

func get_item_sprite_size() -> Vector2:
	if rotated:
		return Vector2(item_sprite_size.y, item_sprite_size.x)
	return item_sprite_size

func get_grid_origin() -> Vector2:
	return global_position - ( get_item_sprite_size() / 2 )

func _process(delta):
	if dragging:
		position = get_global_mouse_position() - offset

func rotate_90() -> void:
	var tween = get_tree().create_tween()
	if rotated:
		tween.tween_property(%Sprite, "rotation_degrees", 0.0, .1)
		InventoryGlobals.rotated.emit(0.0)
	else:
		tween.tween_property(%Sprite, "rotation_degrees", -90.0 , .1)
		InventoryGlobals.rotated.emit(-90.0)
	rotated = !rotated
	await tween.finished
	tween.kill()

func get_item_rotation() -> float:
	return -90.0 if rotated else 0.0

## helper for getting the top left corner of sprite, as origin is centered
func get_origin_offset() -> Vector2:
	return global_position - (get_item_sprite_size() / 2)

func _input(event: InputEvent) -> void:
	if dragging:
		if event is InputEventMouseButton && event.is_pressed():
			if event.button_index == MOUSE_BUTTON_RIGHT:
				rotate_90()

func _on_handle_button_down() -> void:
	dragging = true
	top_level = true
	InventoryGlobals.drag_started.emit(self, item_sprite)
	offset = get_global_mouse_position() - global_position

func _on_handle_button_up() -> void:
	dragging = false
	top_level = false
	var drop_loc = global_position
	InventoryGlobals.drag_stopped.emit(drop_loc)

func _on_area_2d_area_exited(area: Area2D) -> void:
	_overlapping_count -= 1

func _on_area_2d_area_entered(area: Area2D) -> void:
	_overlapping_count += 1
