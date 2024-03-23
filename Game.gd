extends Node2D

# a tmp way to turn off the game by pressing Q
func _input(event):
		if event is InputEventKey and event.pressed:
			if event.keycode == KEY_Q:
				get_tree().quit()
