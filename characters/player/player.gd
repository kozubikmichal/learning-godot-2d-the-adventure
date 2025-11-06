class_name Player
extends CharacterBody2D

@export var move_speed: float = 50.0
@export var push_force: float = 100.0

@onready var life_bar: AnimatedSprite2D = $CanvasLayer/LifeBar
@onready var sword_area: Area2D = $Sword/SwordArea2D
@onready var swing_timer: Timer = $Sword/SwingTimer

var animation_direction: String = "down"
var is_attaching: bool = false

func _enter_tree() -> void:
	position = SceneManager.player_spawn_position

func _ready() -> void:
	$InteractionArea.body_entered.connect(_on_interaction_area_body_entered)
	$InteractionArea.body_exited.connect(_on_interaction_area_body_exited)
	$HitBox.body_entered.connect(_on_hit_box_body_entered)

	sword_area.body_entered.connect(_on_sword_area_body_entered)
	swing_timer.timeout.connect(hide_sword)

	update_life_bar()
	hide_sword()

func _physics_process(_delta: float) -> void:
	compute_velocity()
	process_collision()
	animate()
	update_score_label()
	handle_interaction()
	move_and_slide()

func handle_interaction() -> void:
	if Input.is_action_just_pressed("interact"):
		attack()

func update_score_label() -> void:
	$CanvasLayer/Panel/Label.text = str(GameManager.opened_chest_count)

func compute_velocity() -> void:
	if (is_attaching):
		velocity = Vector2.ZERO
		return

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
		body.enable_interaction()

func _on_interaction_area_body_exited(body: Node) -> void:
	if body.is_in_group("interactable"):
		body.disable_interaction()

func _on_hit_box_body_entered(_body: Node) -> void:
	GameManager.player_hp -= 1
	update_life_bar()
	if GameManager.player_hp <= 0:
		die()

func die() -> void:
	SceneManager.reload_current_2d_scene()
	GameManager.reset_player_hp()

func update_life_bar() -> void:
	life_bar.play(str(GameManager.player_hp) + "_hp")

func _on_sword_area_body_entered(body: Node) -> void:
	body.queue_free()

func hide_sword() -> void:
	$Sword.visible = false
	sword_area.monitoring = false
	is_attaching = false

func attack() -> void:
	is_attaching = true
	$Sword.visible = true
	sword_area.monitoring = true
	$AnimationPlayer.play("attack_" + animation_direction)
	swing_timer.start()
