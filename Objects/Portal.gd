extends Area2D

func _on_body_entered(body):	
	if body.name == "Player":
		if str(get_tree().current_scene.name) == "Game":
			get_tree().change_scene_to_file("res://Views/Levels/LevelOne.tscn")
			
		elif str(get_tree().current_scene.name) == "LevelOne":
			get_tree().change_scene_to_file("res://Views/Levels/Game.tscn")

