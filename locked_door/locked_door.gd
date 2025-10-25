class_name LockedDoor
extends StaticBody2D

@export var activation_buttons: Array[PuzzleButton]

var buttons_pressed: int = 0

func _ready() -> void:
	for button in activation_buttons:
		button.pressed.connect(_on_button_pressed)
		button.unpressed.connect(_on_button_unpressed)

func _on_button_pressed() -> void:
	buttons_pressed += 1

	if buttons_pressed == activation_buttons.size():
		visible = false
		$CollisionShape2D.call_deferred("set_disabled", true)

func _on_button_unpressed() -> void:
	buttons_pressed -= 1

	if buttons_pressed < activation_buttons.size():
		visible = true
		$CollisionShape2D.call_deferred("set_disabled", false)
