class_name PuzzleButton
extends Area2D

signal pressed
signal unpressed

var body_count: int = 0

func _ready() -> void:
	body_entered.connect(_on_body_entered)
	body_exited.connect(_on_body_exited)

func _on_body_entered(body: Node) -> void:
	if (body.is_in_group("pushable") or body is Player):
		body_count += 1
		if (body_count == 1):
			pressed.emit()
			$Sprite.play("pressed")

func _on_body_exited(_body: Node) -> void:
	body_count -= 1

	if body_count == 0:
		unpressed.emit()
		$Sprite.play("unpressed")