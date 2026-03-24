class_name InventoryItem
extends Node2D

@export var snap: int = 128

var dragging: bool = false
var parent_item: Item 

func _ready() -> void:
	InventoryGlobals.drag_started.connect(show_preview)
	InventoryGlobals.drag_stopped.connect(stop_preview)
	position = Vector2(snapped(position.x, snap), snapped(position.y, snap))

func _process(delta):
	if dragging:
		var new_pos = parent_item.global_position
		global_position = Vector2(snapped(new_pos.x, snap), snapped(new_pos.y, snap))
		if !in_grid_bounds() || parent_item.colliding:
			visible = false
		else:
			visible = true

func show_preview(item: Node, texture: Texture2D) -> void:
	parent_item = item
	%Preview.texture = parent_item.item_sprite
	dragging = true
	visible = true

func stop_preview(position: Vector2) -> void:
	if in_grid_bounds():
		if !parent_item.colliding:
			parent_item.global_position = global_position
	dragging = false
	parent_item = null
	visible = false

## helper for inventory's grid bound check on current item being held
func in_grid_bounds() -> bool:
	if %Inventory.in_bounds(global_position, parent_item.item_sprite_size):
		return true
	else:
		return false
