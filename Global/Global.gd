extends Node

var currentScene

const SPEED_PLAYER = 200.0

var inventory = []
var player_node: Node = null
const inventory_slot_scene = preload("res://Views/Inventory/InventorySlot.tscn")
#Custom signals
signal inventory_updated

var isCarrying = false

func _ready():
	inventory.resize(30)
	
func add_item(item):
	print("add_item function")
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i]["type"] == item["type"] and inventory[i]["effect"] == item["effect"]:
			inventory[i]["quantity"] += item["quantity"]
			inventory_updated.emit()
			print("add_item second of same type")
			return true
		elif inventory[i] == null:
			inventory[i] = item
			inventory_updated.emit()
			print("add_item first of same type")
			return true
	return false
	
func remove_item():
	inventory_updated.emit()
	
func increase_inventory_size():
	inventory_updated.emit()

func set_player_reference(player):
	player_node = player
