extends StaticBody2D

func _on_in_tree_body_entered(body):
	if body.name == "Player":
		$PlatformTree1.set_visible(false)
		$BigGren/PlatformTree7.set_visible(false)


func _on_in_tree_body_exited(body):
	if body.name == "Player":
		$PlatformTree1.set_visible(true)
		$BigGren/PlatformTree7.set_visible(true)
