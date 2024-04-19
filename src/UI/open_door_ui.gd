extends Control

signal open_door
signal close_ui

@export var yes_button: Button
# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _on_yes_button_pressed():
		open_door.emit()
		close_ui.emit()
		get_tree().paused = false


func _on_no_button_pressed():
	close_ui.emit()
	get_tree().paused = false

func set_paused(pausing: bool):
	if Global.player.keys > 0:
		yes_button.disabled = false
	else:
		yes_button.disabled = true
	get_tree().paused = pausing
