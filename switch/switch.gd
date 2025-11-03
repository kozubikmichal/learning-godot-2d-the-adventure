extends StaticBody2D
class_name Switch

signal switch_activated
signal switch_deactivated

var can_interact: bool = false

var activated: bool = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact") && can_interact:
		handle_interaction()

func handle_interaction() -> void:
	if activated:
		deactivate_switch()
	else:
		activate_switch()

func activate_switch() -> void:
	$AnimatedSprite2D.play("activated")
	activated = true
	switch_activated.emit()

func deactivate_switch() -> void:
	$AnimatedSprite2D.play("deactivated")
	activated = false
	switch_deactivated.emit()

func enable_interaction() -> void:
	can_interact = true

func disable_interaction() -> void:
	can_interact = false