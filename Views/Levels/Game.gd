extends Node2D

var PlayerSomething = preload("res://Characters/Player/Player.tscn")
var Sleepy = preload("res://Characters/NPC/sleepy.tscn")
var BerryPicker = preload("res://Characters/NPC/berry_picker.tscn")
var Dragon = preload("res://Characters/NPC/dragon.tscn")
var Mushroom = preload("res://Objects/save_point.tscn")

var tmpSleepy
var tmpPicker
var tmpDragon
var tmpPlayer
var pickerInstantiated = false
var denaInstantiated = false
var dragonInstantiated = false

func _init():
	AudioPlayer.play_music_level()
	tmpPlayer = PlayerSomething.instantiate()
	tmpPlayer.position = Vector2(Global.positionX, Global.positionY)
	add_child(tmpPlayer)
	
	tmpSleepy = Sleepy.instantiate()
	tmpSleepy.position = Vector2(2843, 761)
	add_child(tmpSleepy)
	
	var tmpMushroom = Mushroom.instantiate()
	tmpMushroom.position = Vector2(Global.positionX, Global.positionY)
	add_child(tmpMushroom)
	if !Global.savedGame:
		tmpMushroom.set_visible(false)
	else:
		tmpMushroom.position = Vector2(Global.savePointX, Global.savePointY)
	

func _input(event):
	# a tmp way to turn off the game by pressing Q
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_Q:
			get_tree().quit()
	
	# function for pauseing the game
	if Input.is_action_just_pressed("ui_cancel") and !Global.dialogue_is_playing:
		get_tree().paused = true
		$Player/PauseMenuUI.show()
		
	if (event.is_action_pressed("Dash")):
		Global.gameOver = true
		get_tree().change_scene_to_file("res://Views/Menus/Victory.tscn")



func _process(_delta):

	# A game over of sorts, if the health is 0 or less the game will return to the home page
	var tmpPlayerPos = get_node("Player").position.x
	
	if !pickerInstantiated and tmpPlayerPos >= 7600:
		tmpPicker = BerryPicker.instantiate()
		tmpPicker.position = Vector2(8630, 560)
		add_child(tmpPicker)
		pickerInstantiated = true
	
	if !denaInstantiated and tmpPlayerPos >= 9000 and Global.denaRemoved:
		tmpSleepy = Sleepy.instantiate()
		tmpSleepy.position = Vector2(10700, -150)
		add_child(tmpSleepy)
		denaInstantiated = true
	
	if !dragonInstantiated and tmpPlayerPos >= 9500:
		tmpDragon = Dragon.instantiate()
		tmpDragon.position = Vector2(18900, -1550)
		add_child(tmpDragon)
		dragonInstantiated = true
	
	if Global.removeSleepy:
		get_node("Sleepy").queue_free()
		Global.removeSleepy = false
		Global.denaRemoved = true
	
	if Global.justSaved:
		var mushroom = get_node("SavePoint")
		mushroom.position = get_node("Player").position
		mushroom.set_visible(true)
		Global.justSaved = false
	
	if tmpPlayerPos > 7200 and !Global.passedHalfway or Global.overRide:
		Global.passedHalfway = true
		Global.overRide = false
		get_node("MidSavePoint/AnimationPlayer").play("light_up")
		tmpPlayer.save_ui()
		SaveGame.saveGame()
