extends Control
class_name DebugPanel

func _init() -> void:
	ConsoleCommands.connect("debug_enable", func(): visible = true )	
	ConsoleCommands.connect("debug_disable", func(): visible = false )	
