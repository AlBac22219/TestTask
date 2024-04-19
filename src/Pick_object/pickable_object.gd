extends CharacterBody2D

const SPEED = 1800.0
const ACCELERATION = 300.0
@export var icon_sprite: Sprite2D
@export var item_type: InventoryItem:
	set = set_item_type
@export var quantity: int = 0

var player: Player = null
var player_in_range = false
var can_be_pickable: bool = false

func _ready():
	pass

func _physics_process(delta):
	if player_in_range && can_be_pickable:
		if player.inventory.have_free_space():
			var direction = Vector2(player.global_position.x - global_position.x, player.global_position.y - global_position.y)
			direction = direction.normalized()
			velocity.x = move_toward(velocity.x, direction.x * SPEED, ACCELERATION * delta)
			velocity.y = move_toward(velocity.y, direction.y * SPEED, ACCELERATION * delta)
			if global_position.distance_to(player.global_position) < 16:
				pickup_item(player.inventory)
			move_and_slide()

func pickup_item(inventory: Inventory):
	match item_type.item_type:
		InventoryItem.item_types.KEY:
			player.set_keys(player.get_keys() + quantity)
			queue_free()
			return
	inventory.insert_item(item_type, quantity)
	queue_free()

func _on_pick_area_body_entered(body):
	if body.is_in_group("Player"):
		player_in_range = true
		player = body
		can_be_pickable = player.inventory.have_free_space()

func _on_pick_area_body_exited(body):
	if body.is_in_group("Player"):
		player_in_range = false
		player = null
		can_be_pickable = false

func set_item_type(new_item_type: InventoryItem):
	item_type = new_item_type
	if new_item_type:
		icon_sprite.texture = item_type.texture
