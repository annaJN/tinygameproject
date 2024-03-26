extends Node2D

@onready var Pause = $Pause
var pausedGame = false

var global = "res://Global/Global.gd"

# a tmp way to turn off the game by pressing Q
func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_Q:
			get_tree().quit()
	if Input.is_action_just_pressed("Pause"):
		print("game pause game")
		aFunctionThatPrintsSomeText()
		funcPausedGame()

func aFunctionThatPrintsSomeText():
	print("I just printed some text")

func funcPauseGame():
	if pausedGame == false:
		#get_tree().change_scene_to_file("res://Pause.tscn")
		#Pause.hide()
		#Enigine.time_scale = 1
		pass
	else:
		Pause.show()
		#Enigine.time_scale = 0
	
	pausedGame = !pausedGame
