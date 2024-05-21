extends Node

const SAVE_PATH = "res://savegame.bin"

func saveGame():
	var file = FileAccess.open(SAVE_PATH, FileAccess.WRITE)
	var data: Dictionary = {
		"playerHealth": Global.health,
		"xPosition": Global.savePointX,
		"yPosition": Global.savePointY,
		"halfway": Global.passedHalfway,
		"gameSaved": Global.savedGame,
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
				Global.positionX = current_line["xPosition"]
				Global.positionY = current_line["yPosition"]
				Global.savePointX = current_line["xPosition"]
				Global.savePointY = current_line["yPosition"]
				Global.passedHalfway = current_line["halfway"]
				Global.savedGame = current_line["gameSaved"]
				

