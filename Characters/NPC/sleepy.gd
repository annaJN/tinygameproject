extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var anim = get_node("AnimationPlayer")

var sleepyDisappear = false
var sleeping = true
var waking = false

const SPEED = 200.0
const ACCELERATION = 900.0
const FRICTION = 2000.0
const DIRECTION = -1

func _physics_process(delta):
	if not self.is_on_floor():
		velocity.y += gravity * delta
	
	if $AnimationPlayer.get_current_animation() == "sleeping":
		$AnimatedSprite2D.position.y = 150
	elif waking:
		$AnimatedSprite2D.position.y -= 75 * delta
		if $AnimationPlayer.get_current_animation() == "idle":
			waking = false
			Global.sleepyDone = true
	else:
		$AnimatedSprite2D.position.y = 0
		$AnimatedSprite2D.position.x = 70
		
		
	
	if Global.sleepyDone and !sleepyDisappear:
		get_node("AnimatedSprite2D").flip_h = true
		velocity.x = move_toward(velocity.x, SPEED * DIRECTION * -1, ACCELERATION * delta)
		anim.play("walking")
		if self.position.x >= 3500:
			velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
			sleepyDisappear = true
		if sleepyDisappear:
			Global.removeSleepy = true
		
	move_and_slide()

func _on_stone_on_head_collision_body_entered(body):
	if body is RigidBody2D:
		## ska ändras till en annan animation
		## ska vakna upp mer aggresivt när den landar på huvudet vilket är denna funktionen
		wakeUp("wake_up")

func _on_stone_on_the_side_collision_body_entered(body):
	if body is RigidBody2D:
		wakeUp("wake_up")

func wakeUp(animation):
	waking = true
	sleeping = false
	anim.play(animation)
	anim.queue("idle")
##
## Way to check what animation is currently playing:
## $AnimationPlayer.get_current_animation()
