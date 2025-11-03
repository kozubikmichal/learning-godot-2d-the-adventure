extends TileMapLayer
class_name SecretWallLayer

func enable_secret_wall() -> void:
	visible = true
	collision_enabled = true

func disable_secret_wall() -> void:
	visible = false
	collision_enabled = false
