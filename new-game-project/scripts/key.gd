extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

@onready var game = get_node("/root/game")
var is_picked = false
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if is_picked == false:
			NotificationManager.show_message("key", 2.0)
			is_picked = true
			self.scale = Vector2(0.6, 0.6)
			game.add_item(self)
			
		else:
			if Global.is_clicked["key"] == false:
				$glow.visible = true
				Global.is_clicked["key"] = true
			else:
				$glow.visible = false
				Global.is_clicked["key"] = false
