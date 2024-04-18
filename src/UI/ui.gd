extends Control

class_name Hp_and_keys_ui

@export var now_key_label: Label
@export var now_hp_label: Label
@export var max_hp_label: Label

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_hp_label(hp):
	now_hp_label.text = str(hp)

func set_key_label(keys):
	now_key_label.text = str(keys)

func set_max_hp(max_hp):
	max_hp_label.text = str(max_hp)

func update_ui():
	set_key_label(Global.get_player().get_keys())
	set_max_hp(Global.get_player().get_max_hp())
	set_hp_label(Global.get_player().get_hp())
