extends Control

class_name Hp_and_keys_ui

@export var now_key_label: Label
@export var now_hp_label: Label
@export var max_hp_label: Label
@export var owner_of_ui: Player

# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func set_hp_label(hp):
	now_hp_label.text = str(hp)

func set_key_label(keys):
	now_key_label.text = str(keys)

func set_max_hp(max_hp):
	max_hp_label.text = str(max_hp)

func update_ui():
	set_key_label(owner_of_ui.get_keys())
	set_max_hp(owner_of_ui.get_max_hp())
	set_hp_label(owner_of_ui.get_hp())
