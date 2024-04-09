extends Area2D

const Balloon = preload("res://Dialogue/balloon.tscn")

@export var dialogue_resources: DialogueResource
@export var dialogue_start: String = "start"

func action() -> void:
	var balloon: Node = Balloon.instantiate()
	get_tree().current_scene.add_child(balloon)
	balloon.start(dialogue_resources, dialogue_start)
	#DialogueManager.show_example_dialogue_balloon(dialogue_resources, dialogue_start)

