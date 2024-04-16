extends CanvasLayer

func _process(delta):
	$HP.text = "HP " + str(SaveGame.health)
