extends CanvasLayer


@onready var label = $Panel/Label
@onready var icon = $Panel/Sprite2D

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.

func set_item(item):
	label.text = str(item["name"])
	icon.texture = item["icon_texture"]
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_button_button_down():
	self.visible = false
