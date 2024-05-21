extends RigidBody2D

@onready var sprite = $Sprite2D
@onready var highlight = $Highlight

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(_delta):
	pass

func set_highlight_item(state):
	highlight.texture = sprite.texture
	highlight.scale.x = sprite.scale.x + 0.005
	highlight.scale.y = sprite.scale.y + 0.005
	highlight.visible = state
	highlight.position.x = 0
	highlight.position.y = 0
