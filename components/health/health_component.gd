@tool
extends Node2D
class_name HealthComponent

# -----------------------------------------------------------------------------
# HealthComponent 
# Manages health of a parent independantly of the parent (parent is unaware)
# Listens for the `damage_taken` signal from damage_reciever, and emits new 
# health value. Emits `dead` signal when health goes to 0
# -----------------------------------------------------------------------------

signal health_updated(value)
signal dead

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
	if health <= 0:
		dead.emit()

func _ready() -> void:
	damage_reciever.damage_taken.connect(take_damage)

func _get_configuration_warnings() -> PackedStringArray:
	if !damage_reciever:
		return ["No DamageReciever assigned to this Node. It will not be able to recieve damage."]
	return []
