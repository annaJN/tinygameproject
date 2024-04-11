extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

func _physics_process(delta):
	if not self.is_on_floor():
		velocity.y += gravity * delta
	if is_on_floor():
		pass
	
	move_and_slide()
