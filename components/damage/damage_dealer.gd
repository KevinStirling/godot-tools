@tool
extends Area2D
class_name DamageDealer

@export var damage : int = 1

@export var hit_box_shape: Shape2D :
	get: 
		return hit_box_shape
	set(value):
		if Engine.is_editor_hint():
			hit_box_shape = value
			%HitBoxShape.shape = hit_box_shape
