@tool
extends Area2D
class_name DamageReciever

# -----------------------------------------------------------------------------
# DamageReciever
# Component that manages the hurt box for a parent, independantly of parent 
# (parent is unaware). 
# Emits signal of damage amount when damage is taken
# -----------------------------------------------------------------------------

signal damage_taken(amount)

@export var hurt_box_shape : Shape2D :
	get: 
		return hurt_box_shape
	set(value):
		if Engine.is_editor_hint():
			hurt_box_shape = value
			%HurtBoxShape.shape = hurt_box_shape
			update_configuration_warnings()

func take_damage(body : Node2D) -> void :
	if !Engine.is_editor_hint():
		if body is DamageDealer:
			print("took " + str(body.damage) + " damage")
			damage_taken.emit(body.damage)

func _ready() -> void:
	connect("area_entered", take_damage)

func _get_configuration_warnings() -> PackedStringArray:
	if !hurt_box_shape:
		return ["No HurtBoxShape has been set. Will not recieve damage with one."]
	return []
