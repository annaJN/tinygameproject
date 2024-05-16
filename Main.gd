extends Node2D

func _on_start_pressed():
	Global.health = 50
	Global.positionX = 100#75
	Global.positionY = 650#500
	Global.passedHalfway = false
	get_tree().change_scene_to_file("res://Views/Levels/LevelOne.tscn")

## A button to start the last loaded game (hopefully)
func _on_load_pressed():
	SaveGame.loadGame()
	#var startScene = "res://Views/Levels/" + SaveGame.sceneActive + ".tscn"
	get_tree().change_scene_to_file("res://Views/Levels/LevelOne.tscn")

func _on_halfway_pressed():
	if !Global.passedHalfway:
		return
	#ändra till riktiga värden!!!
	Global.positionX = 2000
	Global.positionY = 2000
	get_tree().change_scene_to_file("res://Views/Levels/LevelOne.tscn")

func _on_settings_pressed():
	get_tree().change_scene_to_file("res://Views/Menus/Settings.tscn")

func _on_quit_pressed():
	get_tree().quit()
