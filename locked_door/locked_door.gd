class_name LockedDoor
extends StaticBody2D

@export var activation_button: PuzzleButton

func _ready() -> void:
	if (activation_button):
		activation_button.pressed.connect(_on_button_pressed)
		activation_button.unpressed.connect(_on_button_unpressed)

func _on_button_pressed() -> void:
	visible = false
	$CollisionShape2D.call_deferred("set_disabled", true)

func _on_button_unpressed() -> void:
	visible = true
	$CollisionShape2D.call_deferred("set_disabled", false)