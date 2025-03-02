@tool
extends ProgressBar 

# -----------------------------------------------------------------------------
# HealthBar helper script
# Attach this script to a ProgressBar control node, and assign a HealthComponent
# to the exported `heath_component` variable. The PrgressBar will automatically
# update its value to match that of the assigned HealthComponent
# -----------------------------------------------------------------------------

@export var health_component: HealthComponent :
	set(value):
		health_component = value
		if Engine.is_editor_hint():
			max_value = health_component.health
			update_configuration_warnings()

func update_healthbar(new_value: int) -> void:
	value = new_value

func _ready() -> void:
	if health_component:
		health_component.health_updated.connect(update_healthbar)

func _get_configuration_warnings() -> PackedStringArray:
	if !health_component:
		return ["No health component assigned. Will not recieve health value updates"]
	return []
