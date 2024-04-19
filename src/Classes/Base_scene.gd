extends Node2D

class_name BaseScene

@onready var player: Player = $Player
@onready var tilemap: TileMap = $TileMap
@onready var enterance_markers: Node2D = $Enterance_markers
var tilemap_arr: Array [Vector2i]

# Called when the node enters the scene tree for the first time.
func _ready():
	if Global.player:
		if player:
			player.queue_free()
		player = Global.player
		add_child(player)
	tilemap_arr = tilemap.get_used_cells(2)
	Global.player = player
	player.connect("player_defeated", defeat)
	Global.current_scene = self
	Global.check_is_new_game()
	position_player()

func tp_to_random_place():
	var coord_of_tile = tilemap_arr[randi_range(0, tilemap_arr.size())]
	var tp_position = to_global(tilemap.map_to_local(coord_of_tile))
	player.global_position = tp_position

func defeat():
	Global.change_scene(self, Global.end_scene)

func position_player():
	var marker_name = Global.last_scene_name
	if marker_name.is_empty():
		marker_name = "any"
	marker_name = marker_name.to_lower()
	for enterance in enterance_markers.get_children():
		if enterance is Marker2D and enterance.name.to_lower() == marker_name:
			player.global_position = enterance.global_position
			return
