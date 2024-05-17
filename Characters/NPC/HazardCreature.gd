extends CharacterBody2D

@onready var _follow :PathFollow2D = get_parent()
var _speed :float = 120.0
var knockback_strength = 10.0


# Called when the node enters the scene tree for the first time.
func _ready():
	pass

func _physics_process(delta):
	_follow.set_progress(_follow.get_progress() + _speed * delta)
	if _follow.get_progress_ratio()>0.5 :
		get_node("Hazard").flip_h = false
	elif _follow.get_progress_ratio()<=0.5:
		get_node("Hazard").flip_h = true
	
	
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass 


func _on_area_2d_body_entered(body):
	if body.name == "Player":
		Global.change_health(-5)
		body.enemy_knockback(velocity)
