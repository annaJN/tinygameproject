extends Node2D

var initiateGame = false
var startUp = true

func _ready():
	AudioPlayer.play_music_home()

func _on_start_pressed():
	$Message.text = "Starting Game!"
	Global.health = 50
	Global.positionX = 100
	Global.positionY = 650
	Global.passedHalfway = false
	Global.savedGame = false
	SaveGame.saveGame()
	initiateGame = true
	await get_tree().create_timer(1.8).timeout
	get_tree().change_scene_to_file("res://Views/Levels/LevelOne.tscn")

## A button to start the last loaded game (hopefully)
func _on_load_pressed():
	SaveGame.loadGame()
	if !Global.savedGame:
		$Message.text = "No saved game available"
		return
	if Global.passedHalfway:
		Global.passedHalfway = false
		Global.overRide = true
	initiateGame = true
	await get_tree().create_timer(1.8).timeout
	get_tree().change_scene_to_file("res://Views/Levels/LevelOne.tscn")

func _on_halfway_pressed():
	SaveGame.loadGame()
	if !Global.passedHalfway:
		$Message.text = "You have yet to pass the halfway savepoint"
		return
	Global.passedHalfway = false
	Global.positionX = 7288
	Global.positionY = 558
	initiateGame = true
	await get_tree().create_timer(1.8).timeout
	get_tree().change_scene_to_file("res://Views/Levels/LevelOne.tscn")

func _process(delta):
	if initiateGame:
		var characterAnim = get_node("MushroomRingBackground/DummyPlayer/AnimationPlayer")
		var character = get_node("MushroomRingBackground/DummyPlayer/AnimatedSprite2D")
		characterAnim.play("running")
		if character.position.x > -1250:
			character.position.x -= 750 * delta
	
	if startUp:
		SaveGame.loadGame()
		if !Global.passedHalfway:
			$MushroomRingBackground/CenterContainer/VBoxContainer/Halfway.set_disabled(true)
		if !Global.savedGame:
			$MushroomRingBackground/CenterContainer/VBoxContainer/Load.set_disabled(true)
		startUp = false


func _on_settings_pressed():
	get_tree().change_scene_to_file("res://Views/Menus/AudioSettings.tscn")

func _on_quit_pressed():
	get_tree().quit()
