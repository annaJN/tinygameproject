extends CharacterBody2D

var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
@onready var anim = get_node("AnimationPlayer")

var timelaps = 0
var walk_time = false

const SPEED = 200.0
const ACCELERATION = 900.0
const FRICTION = 2000.0
const DIRECTION = -1

func _physics_process(delta):
	if not self.is_on_floor():
		velocity.y += gravity * delta
	#print($AnimationPlayer.get_current_animation())
	
	if walk_time:
		timelaps += delta
	if timelaps >= 5:
		walk_away(delta)
	if timelaps >= 6:
		walk_time = false
		velocity.x = move_toward(velocity.x, 0, FRICTION * delta)
		_on_area_2d_body_exited(self)
	move_and_slide()

func _on_area_2d_body_entered(body):
	##
	## Way to check what animation is currently playing:
	## $AnimationPlayer.get_current_animation()
	
	if body.name == "Player":
		$AnimatedSprite2D.position.y = 0
		walk_time = true
		anim.play("wake_up")
		anim.queue("idle")


func _on_area_2d_body_exited(_body):
	if walk_time:
		return
	#if body.name == "Player":
	$AnimatedSprite2D.position.y = 70
	anim.play("sleeping")

func walk_away(delta):
	velocity.x = move_toward(velocity.x, SPEED * DIRECTION, ACCELERATION * delta)
	anim.play("walking")
