@tool
class_name Item
extends Node2D

@export var handle: Button

var dragging: bool = false
var offset: Vector2 = Vector2.ZERO
var colliding: bool = false

@export var item_sprite: Texture2D:
	set(value):
		item_sprite = value
		if %Sprite:
			%Sprite.texture = value
@export var item_sprite_size: Vector2 = Vector2(128,128)
@export var collision_shape: Shape2D:
	set(value):
		collision_shape = value
		get_node("Area2D/CollisionShape2D").shape = value

func _ready() -> void:
	handle.size = item_sprite_size

func _process(delta):
	if dragging:
		position = get_global_mouse_position() - offset

func _on_handle_button_down() -> void:
	dragging = true
	top_level = true
	InventoryGlobals.drag_started.emit(self, item_sprite)
	offset = get_global_mouse_position() - global_position

func _on_handle_button_up() -> void:
	dragging = false
	top_level = false
	var drop_loc = global_position + (item_sprite_size / 2)
	InventoryGlobals.drag_stopped.emit(drop_loc)

func _on_area_2d_area_exited(area: Area2D) -> void:
	colliding = false

func _on_area_2d_area_entered(area: Area2D) -> void:
	colliding = true

