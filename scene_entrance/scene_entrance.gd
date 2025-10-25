extends Area2D

@export var scene_path: String
@export var player_spawn_position: Vector2

var enabled: bool = false

func _enter_tree() -> void:
	get_tree().create_timer(0.5).timeout.connect(
		func() -> void:
			enabled = true
	)

func _exit_tree() -> void:
	enabled = false

func _on_body_entered(body: Node2D) -> void:
	if body is Player and enabled:
		print("Changing scene to: ", scene_path, player_spawn_position)
		Global.scene_manager.player_spawn_position = player_spawn_position
		Global.scene_manager.change_2d_scene(scene_path, false, false)

func _on_body_exited(_body: Node2D) -> void:
	pass
