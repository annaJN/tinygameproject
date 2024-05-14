class_name Player extends CharacterBody2D

@export var movement_data : PlayerMovementData

var is_wall_sliding = false

#var health = 50
var carrying = false
var carryingBody : RigidBody2D

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 3
var jump_count = 0
# could be increased if we want a power up or for accessibly purposes
#if we don't want to have double jump, change it to 1
var max_jumps = 2
var time_on_ground = 0
var in_air = false

var currentGround : StaticBody2D
var direction

@onready var actionableFinder: Area2D = $ActionableFinder

@onready var interact_ui = $InteractUI
@onready var inventory_ui = $InventoryUI
@onready var hp = $HP/HP
@onready var animation_player = $AnimationPlayer
@onready var new_item_ui = $NewItemUI

@onready var anim = get_node("AnimationPlayer")

func _ready():
	# Set this node as the player node
	Global.set_player_reference(self)
	movement_data = load(Global.movement)

func _process(_delta):
	## Display the health of the player by a label
	hp.text = "HP " + str(Global.health)

func _physics_process(delta):
	## Add the gravity to the player
	if not is_on_floor():
		velocity.y += gravity * delta

	## Reset the jump count when the player is on the floor/ground
	## Add counter when is on ground, helps with the animations
	## Otherwise, make not on ground variable true
	if is_on_floor():
		jump_count = 0
		time_on_ground += 1
	else:
		in_air = true
	
	wall_sliding_handler(delta)
	## Handle jump (including double jump)
	if Input.is_action_just_pressed("Jump"):
		jumpHandling()
	
	if carrying and carryingBody.is_in_group("Heavy") and get_node("AnimatedSprite2D").flip_h:
		direction = Input.get_action_strength("Right")
	elif carrying and carryingBody.is_in_group("Heavy") and !get_node("AnimatedSprite2D").flip_h:
		direction = 0 - Input.get_action_strength("Left")
	else:
		# Get the input direction and handle the movement/deceleration.
		direction = Input.get_axis("Left", "Right")
	
	# Makes it so character accelerates before hitting top speed
	if direction and !get_tree().paused:
		## Rotates the character depending on direction
		rotateCharacter(direction)
		
		velocity.x = move_toward(velocity.x,movement_data.speed * direction,movement_data.acceleration * delta)
		
		## Start the running animation
		if is_on_floor() and !in_air and time_on_ground > 5:
			anim.play("running")
		
	else:
		velocity.x = move_toward(velocity.x, 0, movement_data.friction * delta)
		# Play idle animation
		if is_on_floor() and !in_air and velocity.y == 0 and velocity.x == 0 and time_on_ground > 5:
			anim.play("idle")

	if carrying:
		if carryingBody.is_in_group("Heavy"):
			if currentGround.name.begins_with("Hallelujah"):
				if self.position.x <= currentGround.position.x:
					carrying = false
				elif self.position.x >= currentGround.position.x + 160:
					carrying = false
			carryingBody.position.x = $Marker2D.global_position.x
			#var bodies = carryingBody.get_colliding_bodies()
			#for body in bodies:
				#if body.name == "Ground":
					#carrying = false
					#Global.movement = "res://Characters/Player/DefaultMovementData.tres"
					#return
		else:
			carryingBody.position = $Marker2D.global_position
	
	move_and_slide()
	
	#slideCollision()
	
	
	landing()
	
	

func _input(event):
	if event.is_action_pressed("Dash"):
		dashing()
	
	if event.is_action_pressed("ui_inventory"):
		inventory()
		
	if (event.is_action_pressed("Down") and is_on_floor()):
		position.y += 15

func _unhandled_input(_event):
	if Input.is_action_just_pressed("interact"):
		var actionables = actionableFinder.get_overlapping_areas()
		if actionables.size() > 0:
			actionables[0].action()
			return

	if Input.is_action_just_pressed("Pickup"):
		var bodies = $ObjectFinder.get_overlapping_bodies()
		if carrying:
			carrying = false
			carryingBody.translate(velocity/7)
			carryingBody.apply_central_impulse(velocity*movement_data.strength)
			carryingBody.freeze = false
			carryingBody.get_node("cool").disabled = false
			carryingBody = null
			Global.movement = "res://Characters/Player/DefaultMovementData.tres"
			return
		
		for body in bodies:
			if !carrying and body is RigidBody2D:
				carrying = true
				carryingBody = body
				
				if body.is_in_group("Heavy"):
					Global.movement = "res://Characters/Player/DragMovement.tres"
					return
				
				carryingBody.freeze = true
				carryingBody.get_node("cool").disabled = true


func inventory():
	inventory_ui.visible = !inventory_ui.visible
	if inventory_ui.visible:
		self.process_mode = 3
		animation_player.stop(false)
	else:
		self.process_mode = 1
		animation_player.play()
	get_tree().paused = !get_tree().paused

func rotateCharacter(directioning):
	if carrying and carryingBody.is_in_group("Heavy"):
		return
	if directioning == -1:
		get_node("AnimatedSprite2D").flip_h = false
		$ActionableFinder.position.x = -100
		$ObjectFinder.position.x = -52
		
		$Marker2D.position.x = -10
	else:
		get_node("AnimatedSprite2D").flip_h = true
		$ActionableFinder.position.x = 12
		$ObjectFinder.position.x = 0
		$Marker2D.position.x = 96

func landing():
	## Animates the landing
	for index in get_slide_collision_count():
		var collision = get_slide_collision(index)
		if collision.get_collider().is_in_group("Landing") and in_air:
			anim.play("landing")
			in_air = false

func jumpHandling():
	if jump_count < max_jumps and !carrying:
		anim.play("jump")
		velocity.y = movement_data.jump_velocity
		jump_count += 1
		time_on_ground = 0
	wall_jump()

func wall_sliding_handler(delta):
	var should_slide : bool = wall_sliding_check()
	if not should_slide:
		return
	velocity.y = movement_data.wall_slide_gravity * delta

#returns if the player fullfills the conditions to be wall sliding
func wall_sliding_check() :
	#guarding clauses and universal constants
	var degree_threshold = 10.0
	var wall_normal = get_wall_normal()
	if not is_on_wall_only() || velocity.y < 0:
		return false
	if Input.is_action_pressed("Right"):
		var right_angle = abs(wall_normal.angle_to(Vector2.RIGHT))
		return wall_normal.is_equal_approx(Vector2.RIGHT) or right_angle < degree_threshold
	elif Input.is_action_pressed("Left"):
		var left_angle = abs(wall_normal.angle_to(Vector2.LEFT))
		return wall_normal.is_equal_approx(Vector2.LEFT) or left_angle < degree_threshold
	return false


#handles wall jumping, makes it so you can jump (for now infinitely) on a wall
func wall_jump():
	var wall_normal = get_wall_normal()
	var left_angle = abs(wall_normal.angle_to(Vector2.LEFT))
	var right_angle = abs(wall_normal.angle_to(Vector2.RIGHT))
	if Input.is_action_just_pressed("ui_accept") and (wall_normal.is_equal_approx(Vector2.RIGHT) or right_angle < 10.0) and is_on_wall_only():
		print("i am right jumping"+str(wall_normal))
		velocity.y = movement_data.jump_velocity
		velocity.x = wall_normal.x * movement_data.speed
		
	if Input.is_action_just_pressed("ui_accept") and (wall_normal.is_equal_approx(Vector2.LEFT) or left_angle < 10.0) and is_on_wall_only():
		print("i am left jumping"+str(wall_normal))
		velocity.y = movement_data.jump_velocity
		velocity.x = wall_normal.x * movement_data.speed

func slideCollision():
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal() * movement_data.push_force)

#handles effects from items
func apply_item_effect(item):
	match item["effect"]:
		"Health": 
			Global.change_health(5)
		_:
			print("There is no effect for this item")
			
			
#handles new item ui
func show_new_item_ui(item):
	new_item_ui.set_item(item)
	new_item_ui.visible = true
	
## 
## Pause menu functionality
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

func dashing():
	self.position.x += 50
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", position + Vector2(50,0), 0.1)

func _on_area_2d_body_entered(body):
	currentGround = body
