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

func show_preview(item: Node, texture: Texture2D) -> void:
	parent_item = item
	%Preview.texture = texture
	dragging = true
	visible = true

func stop_preview(position: Vector2) -> void:
	if %Inventory.in_bounds(position):
		parent_item.global_position = global_position
	dragging = false
	parent_item = null
	visible = false
