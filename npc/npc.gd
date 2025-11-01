extends StaticBody2D
class_name NPC

var can_interact: bool = false

func _ready() -> void:
	$CanvasLayer.visible = false

func _process(_delta: float) -> void:
	if Input.is_action_just_pressed("interact") && can_interact:
		$CanvasLayer.visible = !$CanvasLayer.visible

func enable_interaction() -> void:
	can_interact = true

func disable_interaction() -> void:
	can_interact = false
	$CanvasLayer.visible = false