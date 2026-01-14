class_name Inventory
extends Node
var slots : Array[InventorySlot]
@onready var window : Panel = get_node("InventoryWindow")
@onready var info_text : Label = get_node("InventoryWindow/InfoText")
@export var starter_items : Array[Item]

var inventory_state = null # TODO: uhhhh make this actually a thing

func _ready():
	if inventory_state == null:
		for child in get_node("InventoryWindow/SlotContainer").get_children():
			slots.append(child)
			child.set_item(null)
			child.inventory = self
		for item in starter_items:
			add_item(item)

func _process(delta):
	pass

func on_give_player_item (item : Item, amount : int):
	pass

func add_item(item : Item):
	var slot = get_slot_to_add(item)
	
	if slot == null:
		return
	
	if slot.item == null:
		slot.set_item(item)
	elif slot.item == item:
		slot.add_item()
	
func remove_item(item : Item):
	var slot = get_slot_to_remove(item)
	
	if slot == null or slot.item == item:
		return
	
	slot.remove_item()
	
func get_slot_to_add(item : Item) -> InventorySlot:
	for slot in slots:
		if slot.item == item and slot.quantity < item.max_stack_size:
			return slot
	
	for slot in slots:
		if slot.item == null:
			return null
	
	return null
	
func get_slot_to_remove(item : Item) -> InventorySlot:
	for slot in slots:
		if slot.item == item:
			return slot
	return null
	
func get_number_of_item(item : Item) -> int:
	var total = 0
	
	for slot in slots:
		if slot.item == item:
			total += slot.quantity
			
	return total
	
