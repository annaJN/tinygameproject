extends Node2D

var current_page

@onready var audio = $Audio
@onready var visuals = $Visuals
@onready var controls = $Controls
@onready var movement = $Movement


# Called when the node enters the scene tree for the first time.
func _ready():
	#set_color(audio,0,1,0,0.5)
	#set_color(visuals, 1,1,1,1)
	#set_color(controls,1,1,1,1)
	#set_color(movement,1,1,1,1)
	#current_page = "Audio"
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_audio_pressed():
	get_tree().change_scene_to_file("res://Views/Menus/AudioSettings.tscn")
	current_page = "Audio"
	print(current_page)
	



func _on_visuals_pressed():
	get_tree().change_scene_to_file("res://Views/Menus/VisualSettings.tscn")
	current_page = "Visuals"
	

func _on_controls_pressed():

	get_tree().change_scene_to_file("res://Views/Menus/ControlsSettings.tscn")
	current_page = "Controls"
	


func _on_movement_pressed():
	get_tree().change_scene_to_file("res://Views/Menus/MovementSettings.tscn")
	current_page = "Movement"
	
	
func set_color(node, a, b, c, d):
	node.modulate = Color(a,b,c,d)
