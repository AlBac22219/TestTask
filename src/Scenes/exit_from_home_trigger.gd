extends Area2D

@export var name_of_scene: String

func _on_body_entered(body):
	if body is Player:
		Global.change_scene(get_owner(), name_of_scene)
