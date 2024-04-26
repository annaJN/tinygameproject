extends CanvasLayer

func _process(_delta):
	$HP.text = "HP " + str(Global.health)
