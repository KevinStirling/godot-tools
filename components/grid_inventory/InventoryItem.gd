class_name InventoryItem
extends Node2D

@export var snap: int = 128

var dragging: bool = false
var parent_item: Item

## position of the SubViewportContainer in main scene space
var container_position: Vector2

func _ready() -> void:
	InventoryGlobals.drag_started.connect(show_preview)
	InventoryGlobals.drag_stopped.connect(stop_preview)
	InventoryGlobals.rotated.connect(rotate_preview)
	container_position = get_viewport().get_parent().global_position

## convert main scene position to SubViewport position
func scene_to_viewport(pos: Vector2) -> Vector2:
	return pos - container_position

## convert SubViewport position to main scene position
func viewport_to_scene(pos: Vector2) -> Vector2:
	return pos + container_position

func _process(delta):
	if dragging:
		var grid_origin = %Inventory.global_position
		var pos = scene_to_viewport(parent_item.get_grid_origin())
		var local_pos = pos - grid_origin
		var snapped_local = Vector2(snapped(local_pos.x, snap), snapped(local_pos.y, snap))
		global_position = grid_origin + snapped_local + (parent_item.get_item_sprite_size() / 2)
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
			parent_item.global_position = viewport_to_scene(global_position)
	parent_item = null
	dragging = false
	visible = false

## helper for inventory's grid bound check on current item being held
func in_grid_bounds() -> bool:
	var item_origin = scene_to_viewport(parent_item.get_origin_offset())
	if %Inventory.in_bounds(item_origin, parent_item.get_item_sprite_size()):
		return true
	else:
		return false

func rotate_preview(rot_degrees: float) -> void:
	%Preview.rotation_degrees = rot_degrees
