extends Node2D

func _on_return_pressed():
	get_tree().change_scene_to_file("res://Main.tscn")


func _on_check_button_toggled(toggled_on):
	Global.movement = "res://Characters/Player/AccessibleMovementData.tres"
