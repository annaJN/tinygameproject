extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var anim = get_node("AnimationPlayer")

var timelaps = 0
var sleepyDisappear = false

const SPEED = 200.0
const ACCELERATION = 900.0
const FRICTION = 2000.0
const DIRECTION = -1

func _physics_process(delta):
	if not self.is_on_floor():
		velocity.y += gravity * delta
	
	if $AnimationPlayer.get_current_animation() == "sleeping":
		$AnimatedSprite2D.position.y = 150
	else:
		$AnimatedSprite2D.position.y = 0
		
	
	if Global.sleepyDone and !sleepyDisappear:
		get_node("AnimatedSprite2D").flip_h = true
		velocity.x = move_toward(velocity.x, SPEED * DIRECTION * -1, ACCELERATION * delta)
		startAnimation("walking")
		if self.position.x >= 3500:
			velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
			sleepyDisappear = true
		
		if sleepyDisappear:
			print("SLEEPY SHOULD BE TAKEN AWAY")
			Global.removeSleepy = true
		
	move_and_slide()

func _on_stone_on_head_collision_body_entered(body):
	##
	## Way to check what animation is currently playing:
	## $AnimationPlayer.get_current_animation()
	
	if body is RigidBody2D:
		#startAnimation("wake_up")
		anim.play("wake_up")
		anim.queue("idle")
	
	#if body.name == "Player":
		#$AnimatedSprite2D.position.y = 0
		#walk_time = true
		#anim.play("wake_up")
		#anim.queue("idle")

func _on_stone_on_the_side_collision_body_entered(body):
	if body is RigidBody2D:
		#anim.play("wake_up")
		startAnimation("wake_up")
		print(self.position.x)


func _on_area_2d_body_exited(_body):
	#if walk_time:
		#return
	#if body.name == "Player":
	$AnimatedSprite2D.position.y = 70
	anim.play("sleeping")

func startAnimation(animation : String):
	anim.play(animation)
	#if animation == "wake_up":
		#Global.sleepyDone = true
