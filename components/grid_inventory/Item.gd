@tool
class_name Item
extends Node2D

@export var handle: Button

var dragging: bool = false
var offset: Vector2 = Vector2.ZERO
var colliding: bool = false
var rotated: bool

@export var item_sprite: Texture2D:
	set(value):
		item_sprite = value
		if %Sprite:
			%Sprite.texture = value
@export var item_sprite_size: Vector2 = Vector2(128,128)

func get_item_sprite_size() -> Vector2:
	if rotated:
		return Vector2(item_sprite_size.y, item_sprite_size.x)
	return item_sprite_size
@export var collision_shape: Shape2D:
	set(value):
		collision_shape = value
		get_node("Sprite/Area2D/CollisionShape2D").position -= item_sprite_size / 2
		get_node("Sprite/Area2D/CollisionShape2D").shape = value

func _ready() -> void:
	handle.size = item_sprite_size
	handle.position -= item_sprite_size / 2

func get_grid_origin() -> Vector2:
	return global_position - ( get_item_sprite_size() / 2 )

func _process(delta):
	if dragging:
		position = get_global_mouse_position() - offset

func rotate_90() -> void:
	print("[%s] rotate_90 called, rotated before: %s" % [name, rotated])
	var tween = get_tree().create_tween()
	if rotated:
		tween.tween_property(%Sprite, "rotation_degrees", 0.0, .1)
		InventoryGlobals.rotated.emit(0.0)
	else:
		tween.tween_property(%Sprite, "rotation_degrees", -90.0 , .1)
		InventoryGlobals.rotated.emit(-90.0)
	rotated = !rotated
	await tween.finished
	print("[%s] rotate_90 done, rotated after: %s" % [name, rotated])
	tween.kill()

func get_item_rotation() -> float:
	print("[%s] get_item_rotation, rotated: %s" % [name, rotated])
	return -90.0 if rotated else 0.0

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
	colliding = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	colliding = true
