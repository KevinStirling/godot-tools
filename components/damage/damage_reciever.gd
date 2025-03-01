@tool
extends Area2D
class_name DamageReciever

signal damage_taken

@export var health : int = 20
@export var hurt_box_shape : Shape2D :
	get: 
		return hurt_box_shape
	set(value):
		if Engine.is_editor_hint():
			hurt_box_shape = value
			%HurtBoxShape.shape = hurt_box_shape

func take_damage(body : Node2D) -> void :
	if !Engine.is_editor_hint():
		if body is DamageDealer:
			health -= body.damage
			print("took " + str(body.damage) + " damage")
			print("health = " + str(health))
			damage_taken.emit()

func _ready() -> void:
	connect("area_entered", take_damage)
