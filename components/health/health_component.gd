@tool
extends Node2D
class_name HealthComponent

signal health_updated(value)

@export var health : int = 20
@export var damage_reciever : DamageReciever:
	set(value):
		damage_reciever = value
		if Engine.is_editor_hint():
			update_configuration_warnings()

func take_damage(amount : int):
	health -= amount
	health_updated.emit(health)
	print("hp = " + str(health))

func _ready() -> void:
	damage_reciever.damage_taken.connect(take_damage)

func _get_configuration_warnings() -> PackedStringArray:
	if !damage_reciever:
		return ["No DamageReciever assigned to this Node. It will not be able to recieve damage."]
	return []
