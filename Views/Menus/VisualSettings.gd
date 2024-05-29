extends Node2D

@onready var default = $Default
@onready var accessible = $Accessible
@onready var custom = $Custom
@onready var dialogue_toggle = $DialogueToggle
@onready var parallax_toggle = $ParallaxToggle
@onready var highconstrast_toggle = $HighconstrastToggle

@onready var audio = $SettingsButtons/Audio
@onready var visuals = $SettingsButtons/Visuals
@onready var controls = $SettingsButtons/Controls
@onready var movement = $SettingsButtons/Movement


# Called when the node enters the scene tree for the first time.
func _ready():
	AudioPlayer.play_music_home()
	_on_default_pressed()
	default.button_pressed = true
	
	#set_color(visuals,0,1,0,0.5)
	#set_color(audio, 1,1,1,1)
	#set_color(controls,1,1,1,1)
	#set_color(movement,1,1,1,1)
	visuals.add_theme_color_override("font_color", Color("FFFFFF"))
	var new_stylebox_normal = visuals.get_theme_stylebox("normal").duplicate()
	new_stylebox_normal.bg_color = Color("000")
	new_stylebox_normal.corner_radius_bottom_left = 5
	new_stylebox_normal.corner_radius_bottom_right = 5
	new_stylebox_normal.corner_radius_top_left = 5
	new_stylebox_normal.corner_radius_top_right = 5
	visuals.add_theme_stylebox_override("normal", new_stylebox_normal)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_default_pressed():
	default.button_pressed = true
	set_color(default,0,1,0,0.5)
	set_color(accessible, 1,1,1,1)
	set_color(custom,1,1,1,1)
	dialogue_toggle.button_pressed = true
	parallax_toggle.button_pressed = true
	highconstrast_toggle.button_pressed = false
	


func _on_accessible_pressed():
	accessible.button_pressed = true
	set_color(accessible,0,1,0,0.5)
	set_color(default, 1,1,1,1)
	set_color(custom,1,1,1,1)
	dialogue_toggle.button_pressed = false
	parallax_toggle.button_pressed = false
	highconstrast_toggle.button_pressed = true


func _on_custom_pressed():
	custom.button_pressed = true
	set_color(custom,0,1,0,0.5)
	set_color(accessible, 1,1,1,1)
	set_color(default,1,1,1,1)

func check_if_other_state():
	if (!dialogue_toggle.button_pressed and !parallax_toggle.button_pressed and highconstrast_toggle.button_pressed):
		_on_accessible_pressed()
	elif (dialogue_toggle.button_pressed and parallax_toggle.button_pressed and !highconstrast_toggle.button_pressed):
		_on_default_pressed()
	else:
		_on_custom_pressed()


func set_color(node, a, b, c, d):
	node.modulate = Color(a,b,c,d)


func _on_dialogue_toggle_toggled(toggled_on):
	check_if_other_state()


func _on_parallax_toggle_toggled(toggled_on):
	check_if_other_state()


func _on_highconstrast_toggle_toggled(toggled_on):
	check_if_other_state()

func _on_return_pressed():
	get_tree().change_scene_to_file("res://Main.tscn")
