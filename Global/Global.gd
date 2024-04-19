extends Node

var currentScene

const SPEED_PLAYER = 1000.0
var health
const MAX_HEALTH = 50

var inventory = []
var player_node: Node = null
const inventory_slot_scene = preload("res://Views/Inventory/InventorySlot.tscn")
#Custom signals
signal inventory_updated

var isCarrying = false

func _ready():
	inventory.resize(12)
	
#Inventory stuff
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
	
func remove_item(item_type, item_effect):
	for i in range(inventory.size()):
		if inventory[i] != null and inventory[i]["type"] == item_type and inventory[i]["effect"] == item_effect:
			inventory[i]["quantity"] -=1
			if inventory[i]["quantity"] <= 0:
				inventory[i] = null
			inventory_updated.emit()
			return true
	return false
	
func increase_inventory_size():
	inventory_updated.emit()

func set_player_reference(player):
	player_node = player
	

# global function for adding/removing health
func change_health(amount):
	if (health + amount) > MAX_HEALTH:
		health = MAX_HEALTH
	elif (health + amount) <= 0:
		get_tree().change_scene_to_file("res://Main.tscn")
	else:
		health += amount
	
