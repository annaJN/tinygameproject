extends Node2D

var Player = preload("res://Characters/Player/Player.tscn")

func _init():
	var tmpPlayer = Player.instantiate()
	tmpPlayer.position = Vector2(SaveGame.positionX, SaveGame.positionY)
	add_child(tmpPlayer)


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
		SaveGame.health -= 5

func _process(delta):
	# A game over of sorts, if the health is 0 or less the game will return to the home page
	if SaveGame.health <= 0:
		get_tree().change_scene_to_file("res://Main.tscn")
