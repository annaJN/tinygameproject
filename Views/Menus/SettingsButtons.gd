extends Node2D

var current_page

@onready var audio = $Audio
@onready var visuals = $Visuals
@onready var controls = $Controls
@onready var movement = $Movement


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_audio_pressed():
	get_tree().change_scene_to_file("res://Views/Menus/AudioSettings.tscn")
	current_page = "Audio"



func _on_visuals_pressed():
	get_tree().change_scene_to_file("res://Views/Menus/VisualSettings.tscn")
	current_page = "Visuals"

func _on_controls_pressed():
	pass # Replace with function body.


func _on_movement_pressed():
	get_tree().change_scene_to_file("res://Views/Menus/MovementSettings.tscn")
	current_page = "Movement"
