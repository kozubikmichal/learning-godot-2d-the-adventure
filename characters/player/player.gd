class_name Player
extends CharacterBody2D

@export var move_speed: float = 100.0

func _ready() -> void:
	pass


func _process(delta: float) -> void:
	var input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_vector * move_speed

	move_and_slide()
