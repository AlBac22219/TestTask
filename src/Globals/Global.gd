extends Node

@export var player: Player:
	set = set_player,
	get = get_player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_player(new_player):
	player = new_player

func get_player():
	return player