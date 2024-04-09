extends Node

const SAVE_PATH = "res://savegame.bin"

var health
var positionX
var positionY
var sceneActive

func saveGame():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var data: Dictionary = {
		"playerHealth": health,
		"xPosition": positionX,
		"yPosition": positionY,
		"activeScene": sceneActive,
	}
	var jstr = JSON.stringify(data)
	file.store_line(jstr)

func loadGame():
	print("trying to load a saved game")
