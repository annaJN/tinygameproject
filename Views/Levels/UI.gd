extends CanvasLayer

func _process(delta):
	$HP.text = "HP " + str(Global.health)
