extends CharacterBody2D
class_name SlimeEnemy

@export var chase_speed: float = 50.0
@export var acceleration: float = 5.0
@export var hp: int = 2

var target: Node2D = null

func _ready() -> void:
	$PlayerDetectionArea.body_entered.connect(_on_player_detected)
	$PlayerDetectionArea.body_exited.connect(_on_player_exited)

func _physics_process(_delta: float) -> void:
	if hp <= 0:
		return

	try_chase_target()
	animate_enemy()
	move_and_slide()

func try_chase_target() -> void:
	if target and GameManager.player_hp > 0:
		var direction: Vector2 = (target.global_position - global_position).normalized()

		velocity = velocity.move_toward(direction * chase_speed, acceleration)
	else:
		velocity = Vector2.ZERO

func animate_enemy() -> void:
	var normal_velocity = velocity.normalized()

	if normal_velocity.x > normal_velocity.y:
		$AnimatedSprite2D.play("move_right")
	elif normal_velocity.x < -normal_velocity.y:
		$AnimatedSprite2D.play("move_left")
	elif normal_velocity.y > normal_velocity.x:
		$AnimatedSprite2D.play("move_down")
	elif normal_velocity.y < -normal_velocity.x:
		$AnimatedSprite2D.play("move_up")
	else:
		$AnimatedSprite2D.stop()

func _on_player_detected(body: Node) -> void:
	if body is Player:
		target = body

func _on_player_exited(body: Node) -> void:
	if body is Player:
		target = null

func die() -> void:
	$Particles.emitting = true

	$AnimatedSprite2D.visible = false
	$CollisionShape2D.set_deferred("disabled", true)

	await get_tree().create_timer(1).timeout

	queue_free()

func take_damage() -> void:
	$DamageSFX.play()

	hp -= 1
	if hp <= 0:
		die()