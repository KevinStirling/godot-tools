extends CharacterBody2D

class_name Player

@export var SPEED = 300.0
@export var JUMP_VELOCITY = -400.0
@export var gravity: int = 8800
@export var move_speed: float = 600.0

@onready var state_machine = %StateMachine

func _ready() -> void:
	state_machine.init(self)

func _unhandled_input(event: InputEvent) -> void:
	state_machine.process_input(event)

func _physics_process(delta: float) -> void:
	state_machine.process_physics(delta)

func _process(delta: float) -> void:
	state_machine.process_frame(delta)
