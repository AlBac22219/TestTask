extends CharacterBody2D

class_name Player

signal update_ui
signal player_defeated
@export_category("Nodes_inside_player")
@export var anim_player: AnimationPlayer
@export var drop_markers: Node2D
@export_category("UI_And_inventory")
@export var interact_ui: CanvasLayer
@export var UI: Hp_and_keys_ui
@export var open_door_interact_ui: CanvasLayer
@export var inventory: Inventory
@export_category("HP/Keys")
@export var max_hp: int = 10:
	set = set_max_hp,
	get = get_max_hp
@export var keys: int = 0:
	set = set_keys,
	get = get_keys
var hp: int = 10:
	set = set_hp,
	get = get_hp

const SPEED = 100.0
const ACCELERATION = 400.0

enum movement_states {LEFT, RIGHT, DOWN, UP}
var last_movement_state = movement_states.DOWN

func _ready():
	hp = max_hp
	update_ui.connect(UI.update_ui)
	inventory.connect("droped_item", drop_item)
	update_ui.emit()

func _physics_process(delta):
	var direction = Vector2(Input.get_action_strength("move_right") - Input.get_action_strength("move_left"), 
	Input.get_action_strength("move_down") - Input.get_action_strength("move_up"))
	direction = direction.normalized()
	set_animation(direction)
	velocity.x = move_toward(velocity.x, direction.x * SPEED, ACCELERATION * delta)
	velocity.y = move_toward(velocity.y, direction.y * SPEED, ACCELERATION * delta)
	move_and_slide()

func set_animation(direction):
	if direction.x > 0:
		anim_player.play("walk_right")
		last_movement_state = movement_states.RIGHT
	elif direction.x < 0:
		anim_player.play("walk_left")
		last_movement_state = movement_states.LEFT
	elif direction.y > 0:
		anim_player.play("walk_down")
		last_movement_state = movement_states.DOWN
	elif direction.y < 0:
		anim_player.play("walk_up")
		last_movement_state = movement_states.UP
	else:
		match last_movement_state:
			movement_states.LEFT:
				anim_player.play("stand_left")
			movement_states.RIGHT:
				anim_player.play("stand_right")
			movement_states.DOWN:
				anim_player.play("stand_down")
			movement_states.UP:
				anim_player.play("stand_up")

func get_keys():
	return keys

func set_keys(new_keys):
	keys = new_keys
	update_ui.emit()

func get_hp():
	return hp

func set_hp(new_hp):
	if new_hp > max_hp:
		var difference_between_hp = new_hp - max_hp
		if hp + difference_between_hp <= max_hp:
			hp+= difference_between_hp
			if hp<=0:
				player_defeated.emit()
			update_ui.emit()
		return
	hp = new_hp
	if hp<=0:
		player_defeated.emit()
	update_ui.emit()

func set_max_hp(new_max_hp):
	max_hp = new_max_hp
	if hp > max_hp:
		hp = max_hp
	update_ui.emit()

func get_max_hp():
	return max_hp

func drop_item(item: InventorySlot):
	for i in drop_markers.get_children():
		if i.arr_of_bodyes.size() > 0:
			continue
		else :
			var pick_object = preload("res://src/Pick_object/pickable_object.tscn")
			var inst_pick_object = pick_object.instantiate()
			inst_pick_object.item_type = item.item
			inst_pick_object.quantity = item.quantity
			inst_pick_object.global_position = i.global_position
			get_parent().add_child(inst_pick_object)
			break

func change_interact_visibility(new_visibility):
	interact_ui.visible = new_visibility

func change_interact_text(new_text: String):
	var interact_ui_in_layer: InteractUI = interact_ui.get_child(0)
	interact_ui_in_layer.change_interact_text(new_text)

func change_open_door_visibility(visibility: bool):
	open_door_interact_ui.get_child(0).set_paused(true)
	open_door_interact_ui.visible = visibility


func _on_open_door_ui_close_ui():
	open_door_interact_ui.get_child(0).set_paused(false)
	change_open_door_visibility(false)
