extends Area2D

class_name scene_trugger

@export var alvays_closed: bool = false
@export var closed: bool = true
@export var name_of_scene: String
@export var static_body: StaticBody2D
@export var door: Sprite2D
var can_interact:bool = false
# Called when the node enters the scene tree for the first time.
func _ready():
	if closed:
		door.frame = 0
	else:
		door.frame = 3

func _input(event):
	if event.is_action_pressed("interact") and can_interact and closed:
		Global.player.change_open_door_visibility(true)

func _on_body_entered(body):
	if body is Player:
		can_interact = true
		body.open_door_interact_ui.get_child(0).connect("open_door", yes_button_pressd)
		#Global.change_scene(get_owner(), name_of_scene)

func _on_body_exited(body):
	if body is Player:
		can_interact = false
		body.open_door_interact_ui.get_child(0).disconnect("open_door", yes_button_pressd)

func yes_button_pressd():
	Global.player.keys -=1
	closed = false
	static_body.remove_child(static_body.get_child(0))
	door.frame = 3

func _on_area_2d_body_entered(body):
	if body is Player:
		Global.change_scene(get_owner(), name_of_scene)

func close_door():
	closed = true
	door.frame = 0
	if static_body.get_child_count()==0:
		var collision: CollisionShape2D =CollisionShape2D.new()
		collision.shape = RectangleShape2D.new()
		collision.shape.size = Vector2(16,20)
		collision.position = static_body.position
		static_body.add_child(collision)
