extends RigidBody2D

var picked = false
# const player = "res://Characters/Player/Player.tscn"

func _physics_process(delta):
	#print("physics process")
	if picked == true:
		self.position = get_node("../Player/Marker2D").global_position
		
		

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_C and picked == false:
			var bodies = $Area2D.get_overlapping_bodies()
			for body in bodies:
				print("Body " + str(body))
				if body.name == "Player" and Global.isCarrying == false:
					print("picking up item")
					picked = true
					Global.isCarrying = true
		if event.keycode == KEY_V and picked == true:
			print("dropping item")
			picked = false
			Global.isCarrying = false
			apply_impulse(Vector2(), Vector2(self.position.x+10, self.position.y))
		
