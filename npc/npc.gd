extends StaticBody2D
class_name NPC

@export var dialogue_lines: Array[String] = []

var dialogue_active_line: int = 0

var can_interact: bool = false

func _ready() -> void:
	$CanvasLayer.visible = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact") && can_interact:
		handle_interaction()

func enable_interaction() -> void:
	can_interact = true

func disable_interaction() -> void:
	can_interact = false
	$CanvasLayer.visible = false


func handle_interaction() -> void:
	if dialogue_active_line < dialogue_lines.size():
		$CanvasLayer.visible = true
		get_tree().paused = true
		handle_dialogue()
	else:
		dialogue_active_line = 0
		$CanvasLayer.visible = false
		get_tree().paused = false

func handle_dialogue() -> void:
	$CanvasLayer/DialogLabel.text = dialogue_lines[dialogue_active_line]
	dialogue_active_line += 1