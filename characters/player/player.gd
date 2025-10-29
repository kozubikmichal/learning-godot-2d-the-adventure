class_name Player
extends CharacterBody2D

@export var move_speed: float = 50.0
@export var push_force: float = 100.0

func _enter_tree() -> void:
	position = SceneManager.player_spawn_position

func _physics_process(_delta: float) -> void:
	compute_velocity()
	process_collision()
	animate()
	move_and_slide()


func compute_velocity() -> void:
	var input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = input_vector * move_speed

func process_collision() -> void:
	var collision: KinematicCollision2D = get_last_slide_collision()
	if (!collision):
		return

	var collider = collision.get_collider()
	if (!collider.is_in_group("pushable")):
		return

	var block: RigidBody2D = collider as RigidBody2D
	var collision_normal: Vector2 = collision.get_normal() * -1
	block.apply_central_force(collision_normal * push_force)


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
