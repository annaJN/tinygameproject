extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var anim = get_node("AnimationPlayer")

var timelaps = 0

func _physics_process(delta):
	if not self.is_on_floor():
		velocity.y += gravity * delta
	#print($AnimationPlayer.get_current_animation())
	move_and_slide()


func _on_area_2d_body_entered(body):
	##
	## Way to check what animation is currently playing:
	## $AnimationPlayer.get_current_animation()
	
	if body.name == "Player":
		$AnimatedSprite2D.position.y = 0
		anim.play("wake_up")
		anim.queue("idle")
		


func _on_area_2d_body_exited(body):
	if body.name == "Player":
		$AnimatedSprite2D.position.y = 70
		anim.play("sleeping")
