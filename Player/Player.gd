extends CharacterBody2D


const SPEED = 200.0
const JUMP_VELOCITY = -200.0

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var ground
var jump_count = 0
# could be increased if we want a power up or for accessibly purposes
var max_jumps = 2

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y += gravity * delta

	# Makes sure the jump count is reset when the player is on the floor
	if is_on_floor():
		jump_count = 0
	# Handle jump (including double jump)
	if Input.is_action_just_pressed("ui_accept") and jump_count < max_jumps:
		velocity.y = JUMP_VELOCITY
		jump_count += 1

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction = Input.get_axis("ui_left", "ui_right")
	if direction:
		velocity.x = direction * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _input(event):
		if event is InputEventKey and event.pressed:
			if event.keycode == KEY_D:
				# self.position.x += 50
				var tween = get_tree().create_tween()
				tween.tween_property(self, "position", position + Vector2(50,0), 0.1)
