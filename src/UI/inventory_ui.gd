extends Control

class_name Inventory_UI

@export var inventory: Inventory
@export var slots_grid_container: GridContainer
@export var name_label: Label
@export var description_richlabel: RichTextLabel
@export var button_container: VBoxContainer
var slots: Array
var selected_slot: InventorySlotUi
var slot_information: InventorySlot

func _ready():
	inventory.connect("update_inventory", update)
	create_table()

func _input(event):
	if event.is_action_pressed("open_inventory"):
		get_parent().visible = !get_parent().visible
		get_tree().paused = !get_tree().paused

func create_table():
	var inventory_slot_ui = preload("res://src/UI/inventory_slot.tscn")
	for i in range(inventory.slots.size()):
		var inst_inventory_slot_ui: InventorySlotUi = inventory_slot_ui.instantiate()
		inst_inventory_slot_ui.item_type = inventory.slots[i]
		inst_inventory_slot_ui.id = i
		slots.append(inst_inventory_slot_ui)
		inst_inventory_slot_ui.connect("pressed_on_slot", select)
		slots_grid_container.add_child(inst_inventory_slot_ui)

func update():
	for i in range(min(inventory.slots.size(), slots.size())):
		slots[i].update(inventory.slots[i])
	if selected_slot:
		selected_slot = slots[selected_slot.id]
		await update_components(selected_slot)

func select(slot: InventorySlotUi):
	if selected_slot == slot:
		return
	if selected_slot:
		selected_slot.set_background(1)
	selected_slot = slot
	update_components(slot)

func update_components(item_slot_ui: InventorySlotUi):
	clear_all()
	if item_slot_ui:
		if item_slot_ui.item_type:
			if item_slot_ui.item_type.item != null:
				name_label.text = item_slot_ui.item_type.item.name
				description_richlabel.text = item_slot_ui.item_type.item.description
				add_buttons(item_slot_ui.item_type.item.item_type)
			else:
				name_label.text = "Пусто"
				description_richlabel.text = "Пустая ячейка"
		else:
			name_label.text = "Пусто"
			description_richlabel.text = "Пустая ячейка"

func clear_all():
	name_label.text = ""
	description_richlabel.text = ""
	while button_container.get_child_count() > 0:
		button_container.remove_child(button_container.get_child(0))

func add_buttons(item_type: InventoryItem.item_types):
	match item_type:
		InventoryItem.item_types.USELESS:
			add_use_button(true)
			add_drop_button()
			return
	add_use_button(false)
	add_drop_button()

func add_use_button(disabled: bool):
	var use_button = Button.new()
	use_button.text = "Use"
	use_button.disabled = disabled
	use_button.connect("pressed", use_item)
	button_container.add_child(use_button)

func add_drop_button():
	var drop_button = Button.new()
	drop_button.text = "Drop"
	drop_button.connect("pressed", drop_item)
	button_container.add_child(drop_button)

func drop_item():
	inventory.drop_item(selected_slot.id)
	await update()
	selected_slot = slots[selected_slot.id]
	await update_components(selected_slot)

func use_item():
	match selected_slot.item_type.item.item_type:
		InventoryItem.item_types.HP_BUFF:
			Global.player.max_hp = Global.player.max_hp + selected_slot.item_type.item.max_hp_buff
			Global.player.hp = Global.player.hp + selected_slot.item_type.item.heal
			inventory.use_item(selected_slot.id, 1)
			await update()
			selected_slot = slots[selected_slot.id]
			await update_components(selected_slot)
		InventoryItem.item_types.CLOSING_POTION:
			#Делаю
			close_all_door()
			inventory.use_item(selected_slot.id, 1)
			await update()
			selected_slot = slots[selected_slot.id]
			await update_components(selected_slot)
		InventoryItem.item_types.TP_POTION:
			inventory.use_item(selected_slot.id, 1)
			await update()
			selected_slot = slots[selected_slot.id]
			await update_components(selected_slot)
			Global.current_scene.tp_to_random_place()
		InventoryItem.item_types.AMULETS:
			Global.player.max_hp = Global.player.max_hp + selected_slot.item_type.item.max_hp_buff
			Global.player.hp = Global.player.hp + selected_slot.item_type.item.heal
			inventory.use_item(selected_slot.id, 0)
			await update()
			selected_slot = slots[selected_slot.id]
			await update_components(selected_slot)

func close_all_door():
	var count_of_doors = get_tree().get_nodes_in_group("enter_door")
	if count_of_doors.size()>0:
		get_tree().call_group("enter_door", "close_door")
	else:
		var street: PackedScene = load("res://src/saved_scenes/street.tscn")
		var inst_street = street.instantiate()
		for i in inst_street.houses.get_children():
			i.close_door()
		var scene = PackedScene.new()
		var result = scene.pack(inst_street)
		if result == OK:
			var error = ResourceSaver.save(scene, Global.path_to_save_scenes + "street.tscn")
			if error != OK:
				push_error("An error occurred while saving the scene to disk.")
