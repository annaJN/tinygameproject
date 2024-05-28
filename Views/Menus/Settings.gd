extends Node2D

var checkbuttonen = Global.accessible
@onready var default = $Default
@onready var accessible = $Accessible
@onready var custom = $Custom
@onready var double_jump_toggle = $DoubleJumpToggle
@onready var pause_wall_toggle = $PauseWallToggle


func _ready():
	AudioPlayer.play_music_home()
	set_color(default,0,1,0,0.5)
	set_color(accessible, 1,1,1,1)
	set_color(custom,1,1,1,1)
	
func _process(_delta):
	pass
		
func _on_return_pressed():
	get_tree().change_scene_to_file("res://Main.tscn")
	



func _on_default_active_pressed():
	Global.movement = "res://Characters/Player/DefaultMovementData.tres"
	Global.accessible = false
	


func _on_accessible_active_pressed():
	Global.accessible = true
	Global.movement = "res://Characters/Player/AccessibleMovementData.tres"

func set_color(node, a, b, c, d):
	node.modulate = Color(a,b,c,d)



func _on_default_pressed():
	set_color(default,0,1,0,0.5)
	set_color(accessible, 1,1,1,1)
	set_color(custom,1,1,1,1)
	pause_wall_toggle.button_pressed = false
	double_jump_toggle.button_pressed = false
	


func _on_accessible_pressed():
	set_color(accessible,0,1,0,0.5)
	set_color(default, 1,1,1,1)
	set_color(custom,1,1,1,1)
	pause_wall_toggle.button_pressed = true
	double_jump_toggle.button_pressed = true


func _on_custom_pressed():
	set_color(custom,0,1,0,0.5)
	set_color(accessible, 1,1,1,1)
	set_color(default,1,1,1,1)

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
