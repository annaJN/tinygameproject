extends Node

var currentScene


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if Input.is_action_just_pressed("Pause"):
		print("trying to pause")
		currentScene = get_tree().current_scene.name
		get_tree().change_scene_to_file("res://Pause.tscn")


func pauseGame():
	print("trying to pause again")
	
func unPauseGame():
	pass
