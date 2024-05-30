extends Node2D

@onready var audio = $SettingsButtons/Audio
@onready var visuals = $SettingsButtons/Visuals
@onready var controls = $SettingsButtons/Controls
@onready var movement = $SettingsButtons/Movement

# Called when the node enters the scene tree for the first time.
func _ready():
	AudioPlayer.play_music_home()
	#set_color(audio,0,1,0,0.5)
	#set_color(visuals, 1,1,1,1)
	#set_color(controls,1,1,1,1)
	#set_color(movement,1,1,1,1)
	audio.add_theme_color_override("font_color", Color("FFFFFF"))
	var new_stylebox_normal = audio.get_theme_stylebox("normal").duplicate()
	new_stylebox_normal.bg_color = Color("000")
	new_stylebox_normal.corner_radius_bottom_left = 5
	new_stylebox_normal.corner_radius_bottom_right = 5
	new_stylebox_normal.corner_radius_top_left = 5
	new_stylebox_normal.corner_radius_top_right = 5
	audio.add_theme_stylebox_override("normal", new_stylebox_normal)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_return_pressed():
	get_tree().change_scene_to_file("res://Main.tscn")
	
		
func set_color(node, a, b, c, d):
	node.modulate = Color(a,b,c,d)
