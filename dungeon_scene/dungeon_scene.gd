extends Node2D
class_name DungeonScene

@onready var secret_wall_layer: SecretWallLayer = $SecretWallLayer
@onready var switch_puzzle_manager: SwitchPuzzleManager = $SwitchPuzzleManager

func _ready() -> void:
	switch_puzzle_manager.puzzle_solved.connect(_on_puzzle_solved)
	switch_puzzle_manager.puzzle_failed.connect(_on_puzzle_failed)

func _on_puzzle_solved() -> void:
	secret_wall_layer.disable_secret_wall()

func _on_puzzle_failed() -> void:
	secret_wall_layer.enable_secret_wall()
