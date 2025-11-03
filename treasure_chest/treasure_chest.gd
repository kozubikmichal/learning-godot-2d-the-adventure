extends StaticBody2D
class_name TreasureChest


var is_open: bool = false
var can_interact: bool = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact") && can_interact:
		handle_interaction()

func enable_interaction() -> void:
	can_interact = true

func disable_interaction() -> void:
	can_interact = false

func handle_interaction() -> void:
	if !is_open:
		open_chest()

func open_chest() -> void:
	is_open = true
	$AnimatedSprite2D.play("open")
	$RewardSprite.show()
	$Timer.timeout.connect(_on_Timer_timeout)
	$Timer.start()
	SceneManager.opened_chest_count += 1
	$OpenSound.play()

func _on_Timer_timeout() -> void:
	$RewardSprite.hide()
