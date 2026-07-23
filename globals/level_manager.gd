extends Node

## Global level manager script

var LEVEL_LIST = [
	"res://example_scenes/level_transitions_examples/test_level_1.tscn",
	"res://example_scenes/level_transitions_examples/test_level_2.tscn",
	"res://example_scenes/level_transitions_examples/test_level_3.tscn",
]

const MAIN_MENU_PATH = "res://addons/godot-tools/menus/main_menu.tscn"
const SETTINGS_MENU_PATH = "res://"

func load_scene_from_path(scene_path: String) -> void:
	get_tree().change_scene_to_file(scene_path)

func load_main_menu() -> void:
#	cancel_background_loading()
#	SaveManager.reset_current_game_save_data()
	load_scene_from_path(MAIN_MENU_PATH)
	
func start_new_game() -> void:
#	cancel_background_loading()
#	SaveManager.reset_current_game_save_data()
	load_scene_from_path(LEVEL_LIST[0])
	
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
