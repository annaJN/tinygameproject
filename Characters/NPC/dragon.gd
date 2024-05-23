extends CharacterBody2D

@onready var anim = get_node("AnimationPlayer")


func _process(_delta):
	if Global.startSporeAnimation:
		anim.play("shaking")
		anim.queue("idle")
		Global.startSporeAnimation = false
	
	if Global.talking_to_dragon:
		anim.play("talking")
	else:
		anim.play("idle")
