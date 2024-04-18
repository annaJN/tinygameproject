extends CharacterBody2D


const SPEED = Global.SPEED_PLAYER
const JUMP_VELOCITY = -500.0

#var health = 50

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var ground
var jump_count = 0
# could be increased if we want a power up or for accessibly purposes
#if we don't want to have double jump, change it to 1
var max_jumps = 2

@onready var actionableFinder: Area2D = $ActionableFinder

@onready var interact_ui = $InteractUI
@onready var inventory_ui = $InventoryUI

var push_force = 80.0

const wall_jump_push = 100
const wall_slide_gravity = 50
var is_wall_sliding = false

func _ready():
	# Set this node as the player node
	Global.set_player_reference(self)

func _unhandled_input(event):
	if Input.is_action_just_pressed("interact"):
		var actionables = actionableFinder.get_overlapping_areas()
		if actionables.size() > 0:
			actionables[0].action()
			return


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Makes sure the jump count is reset when the player is on the floor
	if is_on_floor():
		jump_count = 0
	# Handle jump (including double jump)
	if Input.is_action_just_pressed("ui_accept"):
		if jump_count < max_jumps:
			velocity.y = JUMP_VELOCITY
			jump_count += 1
		wall_jump()
		
	wall_sliding(delta)	

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
	for i in get_slide_collision_count():
		var c = get_slide_collision(i)
		if c.get_collider() is RigidBody2D:
			c.get_collider().apply_central_impulse(-c.get_normal() * push_force)

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
		else:
			self.process_mode = 1
		get_tree().paused = !get_tree().paused
		

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