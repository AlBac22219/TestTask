extends Resource

class_name Inventory

signal droped_item(item: InventorySlot)
signal update_inventory
@export var slots: Array[InventorySlot]

func insert_item(item: InventoryItem, quantity_of_item: int):
	for slot in slots:
		if slot.item == item:
			if slot.item["max_quantity"] >= slot.quantity + quantity_of_item:
				slot.quantity += quantity_of_item
				update_inventory.emit()
				return
			else:
				var difference_between_quantities = slot.item["max_quantity"] - slot.quantity
				if difference_between_quantities > 0:
					if slot.item["max_quantity"] >= slot.quantity + difference_between_quantities:
						slot.quantity += difference_between_quantities
						quantity_of_item -= difference_between_quantities
	for i in range(slots.size()):
		if !slots[i].item:
			slots[i].item = item
			slots[i].quantity = quantity_of_item
			update_inventory.emit()
			return

func have_free_space():
	for i in slots:
		if !i.item:
			return true
	return false

func use_item(id_of_item: int, how_many: int):
	if slots[id_of_item].quantity - how_many > 0:
		slots[id_of_item].quantity -= how_many
		return
	else:
		slots[id_of_item] = InventorySlot.new()
		update_inventory.emit()

func drop_item(id_of_item: int):
	var droping_item: InventorySlot = slots[id_of_item]
	slots[id_of_item] = InventorySlot.new()
	update_inventory.emit()
	droped_item.emit(droping_item)
