extends Node2D

var checkbuttonen = Global.accessible
@onready var default = $Default
@onready var accessible = $Accessible
@onready var custom = $Custom
@onready var double_jump_toggle = $DoubleJumpToggle
@onready var pause_wall_toggle = $PauseWallToggle

@onready var audio = $SettingsButtons/Audio
@onready var visuals = $SettingsButtons/Visuals
@onready var controls = $SettingsButtons/Controls
@onready var movement = $SettingsButtons/Movement



func _ready():
	AudioPlayer.play_music_home()
	if(Global.accessible):
		setHighlighted(accessible)
	else:
		setHighlighted(default)
	movement.add_theme_color_override("font_color", Color("FFF"))
	var new_stylebox_normal = movement.get_theme_stylebox("normal").duplicate()
	new_stylebox_normal.bg_color = Color("000")
	new_stylebox_normal.corner_radius_bottom_left = 5
	new_stylebox_normal.corner_radius_bottom_right = 5
	new_stylebox_normal.corner_radius_top_left = 5
	new_stylebox_normal.corner_radius_top_right = 5
	movement.add_theme_stylebox_override("normal", new_stylebox_normal)
	
func _process(_delta):
	pass
	



func _on_default_active_pressed():
	
	Global.movement = "res://Characters/Player/DefaultMovementData.tres"
	Global.accessible = false
	
	


func _on_accessible_active_pressed():
	
	Global.accessible = true
	Global.movement = "res://Characters/Player/AccessibleMovementData.tres"
	

func set_color(node, a, b, c, d):
	node.modulate = Color(a,b,c,d)



func _on_default_pressed():
	print("before default",Global.movement)
	Global.movement = "res://Characters/Player/DefaultMovementData.tres"
	Global.accessible = false
	print("after default",Global.movement)
	setHighlighted(default)
	setDefault(accessible)
	setDefault(custom)
	#set_color(default,0,1,0,0.5)
	#set_color(accessible, 1,1,1,1)
	#set_color(custom,1,1,1,1)
	pause_wall_toggle.button_pressed = false
	double_jump_toggle.button_pressed = false
	


func _on_accessible_pressed():
	print("before accessible",Global.movement)
	Global.accessible = true
	Global.movement = "res://Characters/Player/AccessibleSettingsMovement.tres"
	print("after accessible",Global.movement)
	setHighlighted(accessible)
	setDefault(custom)
	setDefault(default)
	#set_color(accessible,0,1,0,0.5)
	#set_color(default, 1,1,1,1)
	#set_color(custom,1,1,1,1)
	pause_wall_toggle.button_pressed = true
	double_jump_toggle.button_pressed = true
	
func setHighlighted(button):
	var new_stylebox_normal = button.get_theme_stylebox("normal").duplicate()
	new_stylebox_normal.bg_color = Color("7fa12a")
	new_stylebox_normal.border_width_bottom = 2
	new_stylebox_normal.border_width_left = 2
	new_stylebox_normal.border_width_right = 2
	new_stylebox_normal.border_width_top = 2
	new_stylebox_normal.corner_radius_bottom_left = 10
	new_stylebox_normal.corner_radius_bottom_right = 10
	new_stylebox_normal.corner_radius_top_left = 10
	new_stylebox_normal.corner_radius_top_right = 10
	new_stylebox_normal.border_color = Color("7fa12a")
	button.add_theme_color_override("font_color", Color("FFF"))
	
	button.add_theme_stylebox_override("normal", new_stylebox_normal)

func setDefault(button):
	button.add_theme_color_override("font_color", Color("000"))
	var new_stylebox_normal = button.get_theme_stylebox("normal").duplicate()
	new_stylebox_normal.bg_color = Color("d1dab4")
	new_stylebox_normal.border_width_bottom = 0
	new_stylebox_normal.border_width_left = 0
	new_stylebox_normal.border_width_right = 0
	new_stylebox_normal.border_width_top = 0
	new_stylebox_normal.corner_radius_bottom_left = 10
	new_stylebox_normal.corner_radius_bottom_right = 10
	new_stylebox_normal.corner_radius_top_left = 10
	new_stylebox_normal.corner_radius_top_right = 10
	
	button.add_theme_stylebox_override("normal", new_stylebox_normal)
	
	
func _on_custom_pressed():
	setHighlighted(custom)
	setDefault(accessible)
	setDefault(default)
	#set_color(custom,0,1,0,0.5)
	#set_color(accessible, 1,1,1,1)
	#set_color(default,1,1,1,1)

func check_if_other_state():
	if (pause_wall_toggle.button_pressed and !double_jump_toggle.button_pressed) or (!pause_wall_toggle.button_pressed and double_jump_toggle.button_pressed):
		_on_custom_pressed()
	elif (pause_wall_toggle.button_pressed and double_jump_toggle.button_pressed):
		_on_accessible_pressed()
	else:
		_on_default_pressed()

func _on_double_jump_toggle_toggled(toggled_on):
	check_if_other_state()


func _on_pause_wall_toggle_toggled(toggled_on):
	check_if_other_state()
