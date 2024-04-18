extends Button

class_name InventorySlotUi

signal pressed_on_slot(slot: InventorySlotUi)
@export var background: Sprite2D
@export var icon_texture: TextureRect
@export var item_type: InventorySlot:
	set =  set_item_type

var id: int:
	set = set_id,
	get = get_id
# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func set_item_type(new_item_type: InventorySlot):
	item_type = new_item_type
	if new_item_type:
		if new_item_type.item:
			icon_texture.texture = new_item_type.item.texture

func _on_pressed():
	set_background(0)
	pressed_on_slot.emit(self)

func set_id(new_id):
	id = new_id

func get_id():
	return id

func set_background(new_frame: int):
	background.frame = new_frame

func update(slot: InventorySlot):
	if !slot.item:
		icon_texture.texture = null
		item_type = null
	else:
		set_item_type(slot)
