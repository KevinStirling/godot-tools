@tool
class_name Item
extends Node2D

var dragging: bool = false
var offset: Vector2 = Vector2.ZERO

@export var item_sprite: Texture2D:
	set(value):
		item_sprite = value
		if %Sprite:
			%Sprite.texture = value
@export var item_sprite_size: Vector2 = Vector2(128,128):
	set(value):
		item_sprite_size = value
		if %Handle:
			%Handle.size = value	

func _process(delta):
	if dragging:
		position = get_global_mouse_position() - offset

func _on_handle_button_down() -> void:
	dragging = true
	InventoryGlobals.drag_started.emit(self, item_sprite)
	offset = get_global_mouse_position() - global_position

func _on_handle_button_up() -> void:
	dragging = false
	var drop_loc = global_position + (item_sprite_size / 2)
	InventoryGlobals.drag_stopped.emit(drop_loc)
