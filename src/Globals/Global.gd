extends Node

@export var current_scene: Node2D = null
@export var player: Player:
	set = set_player,
	get = get_player
const path_to_save_scenes: String = "res://src/saved_scenes/"
const path_to_new_scenes: String = "res://src/Scenes/"
const end_scene: String = ("res://src/UI/end_game_ui.tscn")
var last_scene_name: String
var is_new_game = true

func set_player(new_player):
	player = new_player

func get_player():
	return player

func change_scene(from: Node2D, to: String):
	if to == end_scene:
		var packed_scene: PackedScene = load(to)
		from.get_tree().change_scene_to_packed(packed_scene)
	else:
		last_scene_name = from.name_of_scene
		player = from.player
		player.get_parent().remove_child(player)
		from.save_scene()
		if FileAccess.file_exists(path_to_save_scenes + to + ".tscn"):
			var full_path = path_to_save_scenes + to + ".tscn"
			from.get_tree().change_scene_to_file(full_path)
		else:
			var full_path: String = path_to_new_scenes + to + ".tscn"
			from.get_tree().change_scene_to_file(full_path)
			#from.get_tree().call_diferred("change_scene_to_file", full_path)

func check_is_new_game():
	if is_new_game:
		is_new_game = false
		var files = DirAccess.get_files_at(path_to_save_scenes)
		for i in files:
			DirAccess.remove_absolute(path_to_save_scenes + i)
