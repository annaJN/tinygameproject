extends Node

const SAVE_PATH = "res://savegame.bin"

var positionX
var positionY
var sceneActive

func saveGame():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var data: Dictionary = {
		"playerHealth": Global.health,
		"xPosition": positionX,
		"yPosition": positionY,
		"activeScene": sceneActive,
	}
	var jstr = JSON.stringify(data)
	file.store_line(jstr)

func loadGame():
	# print("trying to load a saved game")
	var file = FileAccess.open(SAVE_PATH, FileAccess.READ)
	if FileAccess.file_exists(SAVE_PATH) == true:
		if not file.eof_reached():
			var current_line = JSON.parse_string(file.get_line())
			if current_line:
				Global.health = current_line["playerHealth"]
				positionX = current_line["xPosition"]
				positionY = current_line["yPosition"]
				sceneActive = current_line["activeScene"]








