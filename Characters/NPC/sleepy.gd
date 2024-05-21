extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var anim = get_node("AnimationPlayer")

var sleepyDisappear = false
var sleeping = true
var waking = false
var setUpDena = true

const SPEED = 200.0
const ACCELERATION = 900.0
const FRICTION = 2000.0
const DIRECTION = -1

func _physics_process(delta):
	if not self.is_on_floor():
		velocity.y += gravity * delta
	
	if Global.denaRemoved:
		if setUpDena:
			anim.play("idle")
			setUpDena = false
			get_node("StoneOnHeadCollision/coollision").set_disabled(true)
			get_node("StoneOnTheSideCollision/coolision").set_disabled(true)
		
		return
	
	if $AnimationPlayer.get_current_animation() == "sleeping":
		$AnimatedSprite2D.position.y = 140
	elif waking:
		if $AnimationPlayer.get_current_animation() == "wake_up":
			$AnimatedSprite2D.position.y -= 10 * delta
		elif $AnimationPlayer.get_current_animation() == "wake_up_angry":
			#$AnimatedSprite2D.position.y -= 5
			pass
		if $AnimationPlayer.get_current_animation() == "idle":
			waking = false
	else:
		$AnimatedSprite2D.position.y = 0
		$AnimatedSprite2D.position.x = 70
		
	
	if Global.sleepy_dialogue_done and !sleepyDisappear:
		get_node("AnimatedSprite2D").flip_h = true
		velocity.x = move_toward(velocity.x, SPEED * DIRECTION * -1, ACCELERATION * delta)
		anim.play("walking")
		if self.position.x >= 3500:
			velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
			sleepyDisappear = true
		if sleepyDisappear:
			Global.removeSleepy = true
			Global.denaRemoved = true
		
	move_and_slide()
	
	if $AnimationPlayer.get_current_animation() == "wake_up" or $AnimationPlayer.get_current_animation() == "wake_up_angry" and !get_node("StoneOnHeadCollision/coollision").is_disabled():
		disableHitBoxes()
	

func _on_stone_on_head_collision_body_entered(body):
	if body is RigidBody2D:
		## ska ändras till en annan animation
		## ska vakna upp mer aggresivt när den landar på huvudet vilket är denna funktionen
		wakeUp("wake_up_angry")
		$AnimatedSprite2D.position.y = -60
		Global.snorlax_state_angry_at_player = true
		playSound(body)

func _on_stone_on_the_side_collision_body_entered(body):
	if body is RigidBody2D:
		wakeUp("wake_up")
		$AnimatedSprite2D.position.y = 15
		Global.sleepy_awaken = true
		playSound(body)

func playSound(bodyn):
	bodyn.get_node("AudioStreamPlayer").play()

func disableHitBoxes():
	get_node("StoneOnHeadCollision/coollision").set_disabled(true)
	get_node("StoneOnTheSideCollision/coolision").set_disabled(true)

func wakeUp(animation):
	waking = true
	sleeping = false
	anim.play(animation)
	anim.queue("idle")
