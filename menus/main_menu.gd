extends Control

@onready var new_game_button = %NewGameButton
@onready var continue_game_button = %ContinueGameButton
@onready var settings_button = %SettingsButton
@onready var exit_game_button = %ExitGameButton

func new_game() -> void:
	LevelManager.start_new_game()
	
func continue_game() -> void:
	pass

func exit_game() -> void:
	get_tree().quit()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game_button.connect("button_up", new_game)
	continue_game_button.connect("button_up", continue_game)
	exit_game_button.connect("button_up", exit_game)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
