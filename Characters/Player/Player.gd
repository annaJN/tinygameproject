class_name Player extends CharacterBody2D

@export var movement_data : PlayerMovementData

var is_wall_sliding = false

#var health = 50
var carrying = false
var carryingBody : RigidBody2D
var marker_offset : float = 0
var marker_original_offset = 40
# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity") * 3
var jump_count = 0
# could be increased if we want a power up or for accessibly purposes
#if we don't want to have double jump, change it to 1
var max_jumps = 2
var time_on_ground = 0
var in_air = false
var in_range_dialogue = false

var isFacingRight = false

var currentGround : StaticBody2D
var direction
var wallBody = false

@onready var actionableFinder: Area2D = $ActionableFinder

@onready var interact_ui = $InteractUI
@onready var interact_ui_action_label = $InteractUI/Panel/ActionLabel
@onready var interact_ui_key_label = $InteractUI/Panel/Panel/KeyLabel
@onready var inventory_ui = $InventoryUI
@onready var hp = $HP/HP
@onready var animation_player = $AnimationPlayer
@onready var new_item_ui = $NewItemUI
@onready var save_point = $SavePoint
@onready var die_screen = $DieScreen


@onready var anim = get_node("AnimationPlayer")


func _ready():
	# Set this node as the player node
	Global.set_player_reference(self)
	movement_data = load(Global.movement)

func _process(_delta):
	## Display the health of the player by a label
	hp.text = "HP " + str(Global.health)
	
	if self.position.x > 4000 and !Global.denaRemoved:
		Global.removeSleepy = true
		Global.denaRemoved = true
	
	if Global.health <= 0:
		if !Global.savedGame:
			$DieScreen/MenuBar/CenterContainer/VBoxContainer/SavePoint.set_disabled(true)
		if !Global.passedHalfway:
			$DieScreen/MenuBar/CenterContainer/VBoxContainer/Halfway.set_disabled(true)
		get_tree().paused = true
		die_screen.visible = true

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
	if Input.is_action_just_pressed("Jump") and !Global.dialogue_is_playing:
		jumpHandling()
	
	if carrying and carryingBody.is_in_group("Heavy") and isFacingRight:
		direction = Input.get_action_strength("Right")
	elif carrying and carryingBody.is_in_group("Heavy") and !isFacingRight:
		direction = 0 - Input.get_action_strength("Left")
	else:
		# Get the input direction and handle the movement/deceleration.
		direction = Input.get_axis("Left", "Right")
	
	# Makes it so character accelerates before hitting top speed
	if direction and !get_tree().paused and !Global.dialogue_is_playing:
		## Rotates the character depending on direction
		#if direction != self.get_scale().x :
		rotateCharacter(direction)
		velocity.x = move_toward(velocity.x,movement_data.speed * direction,movement_data.acceleration * delta)
		## Start the running animation
		if is_on_floor() and !in_air and time_on_ground > 5:
			if carrying:
				if carryingBody.is_in_group("Heavy"):
					anim.play("pushing")
				else:
					anim.play("item_running")
			else:
				anim.play("running")
		
	else:
		velocity.x = move_toward(velocity.x, 0, movement_data.friction * delta)
		# Play idle animation
		if is_on_floor() and !in_air and velocity.y == 0 and velocity.x == 0 and time_on_ground > 5:
			if carrying:
				if carryingBody.is_in_group("Heavy"):
					#print("IDLE PUSHING ANIMATION")
					anim.play("idle_pushing")
				else:
					anim.play("idle_item")
			else:
				anim.play("idle")

	if carrying:
		carryingBody.set_highlight_item(false)
		if carryingBody.is_in_group("Heavy"):
			if currentGround.name.begins_with("Hallelujah"):
				if self.position.x <= currentGround.position.x + 32 and !isFacingRight:
					carrying = false
				elif self.position.x >= currentGround.position.x + 208 and isFacingRight:
					carrying = false
			carryingBody.position.x = $Marker2D.global_position.x
		else:
			carryingBody.position = $Marker2D.global_position
	
	move_and_slide()
	#knockback = lerp(knockback, Vector2.ZERO, 0.1)
	
	#slideCollision()
	
	landing()
	
func enemy_knockback(enemy_velocity):
	var knockbackdirection = (enemy_velocity - velocity).normalized() * movement_data.knockback_power
	velocity = knockbackdirection
	move_and_slide()
	
func _input(event):
	if event.is_action_pressed("Dash"):
		dashing()
	
	if event.is_action_pressed("ui_inventory"):
		inventory()
		
	if (event.is_action_pressed("Down") and is_on_floor()):
		position.y += 15
		
	if (event.is_action_pressed("ui_add")):
		var items = $ObjectFinder.get_overlapping_bodies()
		for item in items:
			item.pickup_item()
			return

func _unhandled_input(_event):
	if Input.is_action_just_pressed("interact"):
		var actionables = actionableFinder.get_overlapping_areas()
		if actionables.size() > 0:
			Global.dialogue_is_playing = true
			interact_ui.visible = false
			actionables[0].action()
			return

	if Input.is_action_just_pressed("Pickup"):
		var bodies = $ObjectFinder.get_overlapping_bodies()
		if carrying:
			releaseItem()
			return
		for body in bodies:
			if !carrying and body is RigidBody2D:
				$Sounds/ItemPickup.play()
				max_jumps = 1
				carrying = true
				carryingBody = body
				if body.is_in_group("Heavy"):
					anim.play("init_pushing")
				else:
					anim.play("pick_up")
				carryingBody.freeze = true
				carryingBody.get_node("cool").disabled = true
				var tmp_node = carryingBody.get_node("cool")
				match tmp_node.get_class() :
					"CollisionShape2D" :
						$Marker2D.position.x = self.get_scale().x * (marker_original_offset + tmp_node.get_shape().radius)
					"CollisionPolygon2D" :
						var minX = 1000000000
						var maxX = -1000000000
						var rot = tmp_node.transform.get_rotation()
						for vec in tmp_node.polygon:
							var x = vec.rotated(rot).x
							if (x < minX) :
								minX = vec.x
							if (x > maxX) :
								maxX = vec.x
						minX *= tmp_node.transform.get_scale().x
						maxX *= tmp_node.transform.get_scale().x
						$Marker2D.position.x = self.get_scale().x * (marker_original_offset + (maxX - minX)/2.0)
						#TODO find a way to get the width of a collisionpolygon2d
					_ :
						print("Womp womp, object picked up is not of correct class")
				if body.is_in_group("Heavy"):
					Global.movement = "res://Characters/Player/DragMovement.tres"
					carryingBody.freeze = false
					carryingBody.get_node("cool").disabled = false
				return


func releaseItem():
	max_jumps = Global.movement.max_jumps
	carrying = false
	carryingBody.set_axis_velocity(velocity)
	carryingBody.freeze = false
	carryingBody.get_node("cool").disabled = false
	carryingBody = null
	Global.movement = "res://Characters/Player/DefaultMovementData.tres"
	$Marker2D.position.x = marker_original_offset * self.get_scale().x
	$Sounds/ItemDrop.play()

func inventory():
	inventory_ui.visible = !inventory_ui.visible
	if inventory_ui.visible:
		$Sounds/CloseInventory.play()
		self.process_mode = 3
		animation_player.stop(false)
	else:
		$Sounds/OpenInventory.play()
		self.process_mode = 1
		animation_player.play()
	get_tree().paused = !get_tree().paused

func rotateCharacter(directioning):
	if carrying and carryingBody.is_in_group("Heavy"):
		return
	self.set_scale(Vector2(1,directioning))
	self.set_rotation(PI / 2 - (directioning * PI / 2))
	isFacingRight = directioning > 0

func landing():
	## Animates the landing
	for index in get_slide_collision_count():
		var collision = get_slide_collision(index)
		if collision.get_collider().is_in_group("Landing") and in_air:
			anim.play("landing")
			in_air = false

func jumpHandling():
	if jump_count < max_jumps:
		if is_on_floor():
			$Sounds/JumpGround.play()
		else:
			$Sounds/JumpAir.play()
		anim.play("jump")
		if carrying and carryingBody.is_in_group("Heavy"):
			velocity.y = 0
			releaseItem()
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
	if Input.is_action_just_pressed("Jump") and (wall_normal.is_equal_approx(Vector2.RIGHT) or right_angle < 10.0) and is_on_wall_only() and wallBody:
		print("i am right jumping"+str(wall_normal))
		velocity.y = movement_data.jump_velocity
		velocity.x = wall_normal.x * movement_data.speed
		
	if Input.is_action_just_pressed("Jump") and (wall_normal.is_equal_approx(Vector2.LEFT) or left_angle < 10.0) and is_on_wall_only() and wallBody:
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
	$PauseMenuUI/PauseMenu/Save.modulate = Color(1,1,1,1)	
	$PauseMenuUI.hide()
	get_tree().paused = false

func _on_save_pressed():
	Global.savePointX = self.position.x
	Global.savePointY = self.position.y
	Global.savedGame = true
	SaveGame.saveGame()
	Global.savedGame = true
	$PauseMenuUI/PauseMenu/Save.modulate = Color(0,1,0,0.5)
	Global.justSaved = true

func _on_main_menu_pressed():
	get_tree().paused = false
	get_tree().change_scene_to_file("res://Main.tscn")

func dashing():
	self.position.x += 50
	var tween = get_tree().create_tween()
	tween.tween_property(self, "position", position + Vector2(50,0), 0.1)

func _on_area_2d_body_entered(body):
	if body is StaticBody2D:
		currentGround = body


func _on_object_finder_body_entered(body):
	if body.is_in_group("WallJump") and !carrying:
		wallBody = true
	if body.is_in_group("CollectItem") and !in_range_dialogue:
		interact_ui_action_label.text = "collect"
		interact_ui_key_label.text = "F"
		interact_ui.visible = true
		body.set_highlight_item(true)
	if body.is_in_group("CarryItem") and !in_range_dialogue:
		interact_ui_action_label.text = "carry"
		interact_ui_key_label.text = "C"
		interact_ui.visible = true
		body.set_highlight_item(true)
		


func _on_object_finder_body_exited(_body):
	if _body.is_in_group("WallJump"):
		wallBody = false
	elif _body.is_in_group("CollectItem") or _body.is_in_group("CarryItem"):
		interact_ui.visible = false
		_body.set_highlight_item(false)


func _on_actionable_finder_area_entered(_area):
	in_range_dialogue = true
	interact_ui_action_label.text = "talk"
	interact_ui_key_label.text = "E"
	interact_ui.visible = true


func _on_actionable_finder_area_exited(_area):
	in_range_dialogue = false
	interact_ui.visible = false

	
func save_ui():
	save_point.visible = true
	$SavePoint/Timer.start()
	
func _on_timer_timeout():
	save_point.visible = false

func _on_save_point_pressed():
	SaveGame.loadGame()
	if !Global.savedGame:
		$DieScreen/MenuBar/CenterContainer/VBoxContainer/Message.text = "You forgot to save :("
		return
	if Global.passedHalfway:
		Global.passedHalfway = false
		Global.overRide = true
	die_screen.hide()
	get_tree().paused = false
	Global.denaRemoved = false
	Global.denaShouldInitiate = true
	get_tree().reload_current_scene()


func _on_halfway_pressed():
	print("pressing on halfway")
	SaveGame.loadGame()
	if !Global.passedHalfway:
		$DieScreen/MenuBar/CenterContainer/VBoxContainer/Message.text = "Sorry, but you did not get halfway :("
		return
	die_screen.hide()
	get_tree().paused = false
	Global.passedHalfway = false
	Global.positionX = 2050
	Global.positionY = 750
	Global.denaRemoved = false
	Global.denaShouldInitiate = true
	get_tree().reload_current_scene()
