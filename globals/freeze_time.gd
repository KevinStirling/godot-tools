extends Node2D

# Pause all process nodes but keep PhysicsServer2D active
#
# For detecting physics collisions that the player may require
# while other nodes in the game world are paused
func freeze_time() -> void:
	get_tree().paused = true
	PhysicsServer2D.set_active(true)

func resume_time() -> void:
	get_tree().paused = false 
