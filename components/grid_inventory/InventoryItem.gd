class_name InventoryItem
extends Node2D

@export var snap: int = 128

var dragging: bool = false
var parent_item: Item 

func _ready() -> void:
	InventoryGlobals.drag_started.connect(show_preview)
	InventoryGlobals.drag_stopped.connect(stop_preview)
	InventoryGlobals.rotated.connect(rotate_preview)

func _process(delta):
	if dragging:
		var pos = parent_item.get_grid_origin()
		var snapped_origin = Vector2(snapped(pos.x, snap), snapped(pos.y, snap))
		global_position = snapped_origin + (parent_item.get_item_sprite_size() / 2)
		if !in_grid_bounds() || parent_item.colliding:
			visible = false
		else:
			visible = true

# TODO change these function names, they do more now. or perhaps some of it belongs elsewhere
func show_preview(item: Node, texture: Texture2D) -> void:
	parent_item = item
	%Preview.texture = parent_item.item_sprite
	%Preview.rotation_degrees = parent_item.get_item_rotation()
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
	if %Inventory.in_bounds(parent_item.get_origin_offset(), parent_item.get_item_sprite_size()):
		return true
	else:
		return false

func rotate_preview(rot_degrees: float) -> void:
	%Preview.rotation_degrees = rot_degrees
