extends Node2D

var Player = preload("res://Characters/Player/Player.tscn")
var Sleepy = preload("res://Characters/NPC/sleepy.tscn")

var tmpSleepy

func _init():
	var tmpPlayer = Player.instantiate()
	tmpPlayer.position = Vector2(SaveGame.positionX, SaveGame.positionY)
	add_child(tmpPlayer)
	
	tmpSleepy = Sleepy.instantiate()
	tmpSleepy.position = Vector2(2813, 761)
	add_child(tmpSleepy)

func _input(event):
	# a tmp way to turn off the game by pressing Q
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_Q:
			get_tree().quit()
	
	# function for pauseing the game
	if Input.is_action_just_pressed("ui_cancel"):
		print(get_tree().paused)
		get_tree().paused = true
		print(get_tree().paused)
		$Player/Camera2D/PauseMenu.show()

func _on_area_2d_body_entered(body):
	if body.name == "Player":
		Global.change_health(-5)

func _process(_delta):
	# A game over of sorts, if the health is 0 or less the game will return to the home page
	
	if Global.removeSleepy:
		print("REMOVING SLEEPY")
		get_node("Sleepy").queue_free()
		Global.removeSleepy = false
		
	
	#if SaveGame.health <= 0:
		#get_tree().change_scene_to_file("res://Main.tscn")
