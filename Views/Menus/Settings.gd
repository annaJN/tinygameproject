extends Node2D

var checkbuttonen = Global.accessible

func _ready():
	AudioPlayer.play_music_home()
	
func _process(_delta):
	pass
	#if Global.accessible:
		#set_color($DefaultActive, 1,1,1,1)
		#set_color($AccessibleActive, 0,1,0,0.5)
		
	#else:
		#set_color($DefaultActive, 0,1,0,0.5)
		#set_color($AccessibleActive, 1,1,1,1)
		
func _on_return_pressed():
	get_tree().change_scene_to_file("res://Main.tscn")


func _on_default_active_pressed():
	Global.movement = "res://Characters/Player/DefaultMovementData.tres"
	Global.accessible = false
	


func _on_accessible_active_pressed():
	Global.accessible = true
	Global.movement = "res://Characters/Player/AccessibleMovementData.tres"

func set_color(node, a, b, c, d):
	node.modulate = Color(a,b,c,d)
