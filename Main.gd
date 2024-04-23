extends Node2D

func _on_start_pressed():
	Global.health = 50
	SaveGame.positionX = 75
	SaveGame.positionY = 500
	get_tree().change_scene_to_file("res://Views/Levels/Home.tscn")

func _on_settings_pressed():
	get_tree().change_scene_to_file("res://Views/Menus/Settings.tscn")

func _on_quit_pressed():
	get_tree().quit()

## A button to start the last loaded game (hopefully)
func _on_load_pressed():
	SaveGame.loadGame()
	var startScene = "res://Views/Levels/" + SaveGame.sceneActive + ".tscn"
	get_tree().change_scene_to_file(startScene)
	
