extends CharacterBody2D

const SPEED = Global.SPEED_PLAYER
const JUMP_VELOCITY = -700.0

#var health = 50
var carrying = false

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 3
var ground
var jump_count = 0
# could be increased if we want a power up or for accessibly purposes
#if we don't want to have double jump, change it to 1
var max_jumps = 2

@onready var actionableFinder: Area2D = $ActionableFinder

@onready var interact_ui = $InteractUI
@onready var inventory_ui = $InventoryUI
@onready var hp = $HP/HP
@onready var animation_player = $AnimationPlayer

@onready var anim = get_node("AnimationPlayer")
var time_on_ground = 0

var push_force = 80.0

const wall_jump_push = 100
const wall_slide_gravity = 50
var is_wall_sliding = false

var in_air = false

func _ready():
	# Set this node as the player node
	Global.set_player_reference(self)

func _unhandled_input(event):
	if Input.is_action_just_pressed("interact"):
		var actionables = actionableFinder.get_overlapping_areas()
		if actionables.size() > 0:
			actionables[0].action()
			return
	
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_P:
			print("p is pressed")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Makes sure the jump count is reset when the player is on the floor
	if is_on_floor():
		jump_count = 0
	else:
		in_air = true
	# Handle jump (including double jump)
	if Input.is_action_just_pressed("ui_accept"):
		if jump_count < max_jumps && Global.isCarrying == false:
			anim.play("jump")
			velocity.y = JUMP_VELOCITY
			jump_count += 1
			time_on_ground = 0
		wall_jump()
		
	wall_sliding(delta)

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction and !get_tree().paused:
		##
		## Rotates the character depending on direction
		if direction == -1:
			get_node("AnimatedSprite2D").flip_h = false
		else:
			get_node("AnimatedSprite2D").flip_h = true
		velocity.x = direction * SPEED
		##
		## Start the running animation
		if is_on_floor() and !in_air and time_on_ground > 5:
			anim.play("running")
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		if is_on_floor() and !in_air and velocity.y == 0 and velocity.x == 0 and time_on_ground > 5:
			anim.play("idle")

	move_and_slide()
	
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)
			
	##
	## Animates the landing
	for index in get_slide_collision_count():
		var collision = get_slide_collision(index)
		if collision.get_collider().is_in_group("Landing") and in_air:
			anim.play("landing")
			in_air = false

func _process(_delta):
	hp.text = "HP " + str(Global.health)
	
	if is_on_floor():
		time_on_ground += 1

func _input(event):
	if event is InputEventKey and event.pressed:
		if event.keycode == KEY_D:
			# self.position.x += 50
			var tween = get_tree().create_tween()
			tween.tween_property(self, "position", position + Vector2(50,0), 0.1)
	if event.is_action_pressed("ui_inventory"):
		inventory_ui.visible = !inventory_ui.visible
		if inventory_ui.visible:
			self.process_mode = 3
			animation_player.stop(false)
			
		else:
			self.process_mode = 1
			animation_player.play()
		get_tree().paused = !get_tree().paused
		
	if (event.is_action_pressed("ui_down") && is_on_floor()):
		position.y += 15
		

#handles wall sliding, makes it so gravity is slower when you are climbing a wall
func wall_sliding(delta):
	if is_on_wall() and !is_on_floor():
		if Input.is_action_pressed("ui_left") or Input.is_action_pressed("ui_right"):
			is_wall_sliding=true
		else:
			is_wall_sliding = false
		
		if is_wall_sliding:
			velocity.y += (wall_slide_gravity*delta)
			velocity.y = min(velocity.y, wall_slide_gravity)
	
#handles wall jumping, makes it so you can jump (for now infinitely) on a wall
func wall_jump():
	if Input.is_action_pressed("ui_right") and is_on_wall():
		velocity.y = JUMP_VELOCITY
		velocity.x = -wall_jump_push
	if Input.is_action_pressed("ui_left") and is_on_wall():
		velocity.y = JUMP_VELOCITY
		velocity.x = wall_jump_push

#handles effects from items
func apply_item_effect(item):
	match item["effect"]:
		"Health": 
			Global.change_health(5)
		_:
			print("There is no effect for this item")
			
## 
## Pause menu functionality
##
func _on_resume_pressed():
	$Camera2D/PauseMenu/Save.modulate = Color(1,1,1,1)	
	$Camera2D/PauseMenu.hide()
	get_tree().paused = false

func _on_save_pressed():
	SaveGame.positionX = self.position.x
	SaveGame.positionY = self.position.y
	SaveGame.sceneActive = get_tree().current_scene.name
	SaveGame.saveGame()
	$Camera2D/PauseMenu/Save.modulate = Color(0,1,0,0.5)
	

func _on_main_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Main.tscn")
