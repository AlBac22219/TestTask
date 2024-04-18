extends Node2D

@export var player: Player

# Called when the node enters the scene tree for the first time.
func _ready():
	player.connect("player_defeated", defeat)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func defeat():
	print("Помер")
