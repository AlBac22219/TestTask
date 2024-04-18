extends Resource

class_name InventoryItem

enum item_types {KEY, HP_BUFF, CLOSING_POTION, TP_POTION, USELESS, AMULETS}

@export var texture: Texture2D
@export var name: String
@export var description: String
@export var max_quantity: int
@export var item_type: item_types
@export var heal: int = 0
@export var max_hp_buff: int = 0
