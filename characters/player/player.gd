class_name Player
extends CharacterBody2D

@export var move_speed: float = 50.0
@export var push_force: float = 100.0
@export var knockback_strength: float = 150.0
@export var acceleration: float = 10.0

@onready var life_bar: AnimatedSprite2D = $CanvasLayer/LifeBar
@onready var sword_area: Area2D = $Sword/SwordArea2D
@onready var swing_timer: Timer = $Sword/SwingTimer

var animation_direction: String = "down"
var is_attaching: bool = false

var can_attack: bool = true

func _enter_tree() -> void:
	position = SceneManager.player_spawn_position

func _ready() -> void:
	$InteractionArea.body_entered.connect(_on_interaction_area_body_entered)
	$InteractionArea.body_exited.connect(_on_interaction_area_body_exited)
	$HitBox.body_entered.connect(_on_hit_box_body_entered)

	sword_area.body_entered.connect(_on_sword_area_body_entered)
	swing_timer.timeout.connect(hide_sword)

	$DeathTimer.timeout.connect(_on_DeathTimer_timeout)

	update_life_bar()
	hide_sword()

func _physics_process(_delta: float) -> void:
	if GameManager.player_hp <= 0:
		return

	compute_velocity()
	process_collision()
	animate()
	update_score_label()
	handle_interaction()
	move_and_slide()

func handle_interaction() -> void:
	if Input.is_action_just_pressed("interact") && can_attack:
		attack()

func update_score_label() -> void:
	$CanvasLayer/Panel/Label.text = str(GameManager.opened_chest_count)

func compute_velocity() -> void:
	if (is_attaching):
		velocity = Vector2.ZERO
		return

	var input_vector = Input.get_vector("move_left", "move_right", "move_up", "move_down")
	velocity = velocity.move_toward(input_vector * move_speed, acceleration)

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
	var stop = false

	if (is_attaching):
		$AnimatedSprite2D.play("attack_" + animation_direction)
		return

	if (velocity.x > 0):
		animation_direction = "right"
		$InteractionArea.position = Vector2(8, 0)
	elif (velocity.x < 0):
		animation_direction = "left"
		$InteractionArea.position = Vector2(-8, 0)
	elif (velocity.y < 0):
		animation_direction = "up"
		$InteractionArea.position = Vector2(0, -8)
	elif (velocity.y > 0):
		animation_direction = "down"
		$InteractionArea.position = Vector2(0, 8)
	else:
		stop = true

	$AnimatedSprite2D.play("move_" + animation_direction)

	if stop:
		$AnimatedSprite2D.stop()


func _on_interaction_area_body_entered(body: Node) -> void:
	if body.is_in_group("interactable"):
		can_attack = false
		body.enable_interaction()

func _on_interaction_area_body_exited(body: Node) -> void:
	if body.is_in_group("interactable"):
		can_attack = true
		body.disable_interaction()

func _on_hit_box_body_entered(body: Node2D) -> void:
	var distance_to_player = (global_position - body.global_position).normalized()
	velocity += distance_to_player * knockback_strength

	take_damage()

func take_damage() -> void:
	GameManager.player_hp -= 1
	update_life_bar()
	if GameManager.player_hp <= 0:
		die()

	flash_body(self)
	$DamageSFX.play()

func flash_body(body: Node2D, color = Color(10, 10, 10)) -> void:
	var flash_white_color = color

	body.modulate = flash_white_color

	await get_tree().create_timer(0.2).timeout

	if (is_instance_valid(body)):
		body.modulate = Color(1, 1, 1)

func die() -> void:
	$AnimatedSprite2D.play("death")

	$DeathTimer.start()

func _on_DeathTimer_timeout() -> void:
	SceneManager.reload_current_2d_scene()
	GameManager.reset_player_hp()

func update_life_bar() -> void:
	life_bar.play(str(GameManager.player_hp) + "_hp")

func _on_sword_area_body_entered(body: Node2D) -> void:
	var knockback_direction = (body.global_position - global_position).normalized()
	body.velocity += knockback_direction * knockback_strength

	flash_body(body, Color(5, 0, 0))
	body.take_damage()

func hide_sword() -> void:
	$Sword.visible = false
	sword_area.monitoring = false
	is_attaching = false

func attack() -> void:
	if !swing_timer.is_stopped():
		return

	is_attaching = true
	$Sword.visible = true
	$AnimationPlayer.play("attack_" + animation_direction)
	$SwordSFX.play()
	sword_area.monitoring = true
	swing_timer.start()
