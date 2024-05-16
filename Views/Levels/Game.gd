extends Node2D

var PlayerSomething = preload("res://Characters/Player/Player.tscn")
var Sleepy = preload("res://Characters/NPC/sleepy.tscn")
var Dragon = preload("res://Characters/NPC/dragon.tscn")
var Mushroom = preload("res://Objects/save_point.tscn")

var tmpSleepy
var tmpDragon
var dragonInstantiated = false

func _init():
	var tmpPlayer = PlayerSomething.instantiate()
	tmpPlayer.position = Vector2(Global.positionX, Global.positionY)
	add_child(tmpPlayer)
	
	tmpSleepy = Sleepy.instantiate()
	tmpSleepy.position = Vector2(2813, 761)
	add_child(tmpSleepy)
	
	var tmpMushroom = Mushroom.instantiate()
	tmpMushroom.position = Vector2(Global.positionX, Global.positionY)
	add_child(tmpMushroom)
	if !Global.savedGame:
		tmpMushroom.set_visible(false)
	

func _input(event):
	# a tmp way to turn off the game by pressing Q
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_Q:
			get_tree().quit()
	
	# function for pauseing the game
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().paused = true
		$Player/Camera2D/PauseMenu.show()

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		Global.change_health(-5)

func _process(_delta):
	# A game over of sorts, if the health is 0 or less the game will return to the home page
	var tmpPlayerPos = get_node("Player").position.x
	
	if !dragonInstantiated and tmpPlayerPos >= 9500:
		tmpDragon = Dragon.instantiate()
		tmpDragon.position = Vector2(11000, 60)
		add_child(tmpDragon)
		dragonInstantiated = true
	
	if Global.removeSleepy:
		get_node("Sleepy").queue_free()
		Global.removeSleepy = false
	
	if Global.justSaved:
		var mushroom = get_node("SavePoint")
		mushroom.position = get_node("Player").position
		mushroom.set_visible(true)
		Global.justSaved = false
	
	if tmpPlayerPos > 2000 and !Global.passedHalfway:
		Global.passedHalfway = true
		get_node("MidSavePoint/AnimationPlayer").play("light_up")
		SaveGame.saveGame()
	
	#if SaveGame.health <= 0:
		#get_tree().change_scene_to_file("res://Main.tscn")
