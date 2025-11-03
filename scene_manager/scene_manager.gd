extends Node

var player_spawn_position: Vector2

var current_2d_scene: Node2D
var current_2d_scene_path: String

var current_gui_scene: Control
var current_gui_scene_path: String

var scene_cache: Dictionary = {}

@onready var world_2d: Node2D = $World2D
@onready var gui: Control = $GUI

var opened_chest_count: int = 0

func _ready() -> void:
	var current_scene = get_tree().current_scene

	if (current_scene):
		get_tree().root.call_deferred("remove_child", current_scene)

		if (current_scene is Node2D):
			world_2d.call_deferred("add_child", current_scene)
			get_tree().root.set_deferred("current_scene", current_scene)
			current_2d_scene = current_scene
			current_2d_scene_path = current_scene.scene_file_path
		elif (current_scene is Control):
			gui.call_deferred("add_child", current_scene)
			get_tree().root.set_deferred("current_scene", current_scene)
			current_gui_scene = current_scene
			current_gui_scene_path = current_scene.scene_file_path

func get_cached_scene(scene_path: String) -> Node:
	if scene_cache.has(scene_path):
		return scene_cache[scene_path]

	var scene = load(scene_path).instantiate()
	scene_cache[scene_path] = scene
	return scene

func remove_cached_scene(scene_path: String) -> void:
	if scene_cache.has(scene_path):
		scene_cache.erase(scene_path)

func change_gui_scene(new_scene: String, delete: bool = true, keep_running: bool = false) -> void:
	if (current_gui_scene):
		if (delete):
			current_gui_scene.queue_free()
			remove_cached_scene(current_gui_scene_path)
		elif keep_running:
			current_gui_scene.visible = false
		else:
			gui.call_deferred("remove_child", current_gui_scene)

	var new = get_cached_scene(new_scene) as Control
	gui.call_deferred("add_child", new)
	current_gui_scene = new
	current_gui_scene_path = new_scene

func change_2d_scene(new_scene: String, delete: bool = true, keep_running: bool = false) -> void:
	if (current_2d_scene):
		if (delete):
			current_2d_scene.queue_free()
			remove_cached_scene(current_2d_scene_path)
		elif keep_running:
			current_2d_scene.visible = false
		else:
			world_2d.call_deferred("remove_child", current_2d_scene)

	var new = get_cached_scene(new_scene) as Node2D
	world_2d.call_deferred("add_child", new)
	current_2d_scene = new
	current_2d_scene_path = new_scene
