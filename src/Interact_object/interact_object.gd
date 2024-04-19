extends StaticBody2D

@export var interact_text_arr: Array[String]
@export var ray_cast: RayCast2D
@export var texture_of_object:Texture2D
var player: Player = null
var player_in_interact_zone: bool = false
var player_can_interact: bool = true
var text_id:int = 0

func _ready():
	$Sprite2D.texture = texture_of_object

func _process(_delta):
	if player:
		ray_cast.target_position.x =  to_local(player.global_position).x
		ray_cast.target_position.y =  to_local(player.global_position).y + 5.0
		set_player_can_interact()

func _input(event):
	if event.is_action_pressed("interact") && player_in_interact_zone && player_can_interact:
		if player.last_movement_state == calculate_needed_player_vision():
			player.change_interact_text(interact_text_arr[text_id])
			text_id += 1
			if text_id >= interact_text_arr.size():
				text_id = 0

func _on_area_2d_body_entered(body):
	if body.is_in_group("Player"):
		player = body
		player_in_interact_zone = true

func _on_area_2d_body_exited(body):
	if body.is_in_group("Player"):
		if player.interact_ui.visible:
			player.change_interact_visibility(false)
		player = null
		player_in_interact_zone = false
		text_id = 0

func set_player_can_interact():
	if ray_cast.get_collider():
		if ray_cast.get_collider() is Player:
			player_can_interact = true
		else :
			player_can_interact = false

func calculate_needed_player_vision() -> Player.movement_states:
	var player_position = ray_cast.target_position
	if abs(player_position.y) > abs(player_position.x):
		if player_position.y > 0:
			return Player.movement_states.UP
		else:
			return Player.movement_states.DOWN
	else :
		if player_position.x > 0:
			return Player.movement_states.LEFT
		else:
			return Player.movement_states.RIGHT
