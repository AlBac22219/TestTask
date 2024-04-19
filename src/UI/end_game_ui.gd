extends Control

@export var button: Button
@export var animation_player: AnimationPlayer
@export var camera: Camera2D

# Called when the node enters the scene tree for the first time.
func _ready():
	get_tree().paused = false
	camera.make_current()

func _on_button_pressed():
	get_tree().quit()


func _on_timer_timeout():
	button.visible = true
	button.disabled = false
