extends Control

class_name InteractUI

@export var interact_label: RichTextLabel
@export var life_timer: Timer
@export var time_for_timer: float = 10

var old_text: String = ""

func change_interact_text(new_text: String):
	interact_label.text = new_text
	get_parent().visible = true
	life_timer.start(time_for_timer)


func _on_life_timer_timeout():
	get_parent().visible = !get_parent().visible
