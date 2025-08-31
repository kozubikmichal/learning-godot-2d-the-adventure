class_name Player
extends CharacterBody2D

@export var move_speed: float = 50.0

func _ready() -> void:
	position = SceneManager.player_spawn_position

func _process(_delta: float) -> void:
	var input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_vector * move_speed

	animate()
	move_and_slide()


func animate():
	if (velocity.x > 0):
		$AnimatedSprite2D.play("move_right")
	elif (velocity.x < 0):
		$AnimatedSprite2D.play("move_left")
	elif (velocity.y < 0):
		$AnimatedSprite2D.play("move_up")
	elif (velocity.y > 0):
		$AnimatedSprite2D.play("move_down")
	else:
		$AnimatedSprite2D.stop()
