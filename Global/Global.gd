extends Node

#dialogue variables 
var has_given_Starberry = false

var accessible : bool
#var currentScene

var positionX
var positionY
var savedGame
var justSaved
var passedHalfway

var movement = "res://Characters/Player/DefaultMovementData.tres"

#const SPEED_PLAYER = 400.0
var health
const MAX_HEALTH = 50

var inventory = []
var player_node: Node = null
const inventory_slot_scene = preload("res://Views/Inventory/InventorySlot.tscn")
#Custom signalssignal inventory_updated

var sleepyDone = false
var removeSleepy = false

var snorlax_state_angry_at_player = false
var sleepy_awaken = false
var sleepy_dialogue_done = false
var dena_in_village = false
var dena_not_met = false

signal inventory_updated

  
var acorn = {
		"quantity" : 1,
		"type" : "Collectible",
		"name" : "Acorn",
		"effect" : "",
		"texture" : load("res://Assets/Environment/Woodsy/acorn.png"),
		"scene_path" : "res://Objects/InventoryItem.tscn",
		"icon_texture": load("res://Assets/Environment/Woodsy/acorn.png")
	}

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
	
#Global function for checking if the player has a certain item in their inventory
#Takes item_name 
func check_item_in_inventory(item_name):
	for i in range(inventory.size()):
		if(inventory[i] != null and inventory[i]["name"] == item_name):
			return true
	return false
	
func new_item_ui(item):
	print("i got here")
	player_node.show_new_item_ui(item)
