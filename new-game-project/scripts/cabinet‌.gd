extends Area2D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

@export var key: Area2D
@export var wire: Area2D
@export var game: Node2D
func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT and Global.is_opened["cabinet"] == false:
		if Global.is_clicked["key"] == true:
			NotificationManager.show_message("The cabinet is opened!", 2.0)
			$Sprite2D.texture = load("res://assets/opened_cabinet.png")
			game.use_item(Global.item_pos["key"][0],Global.item_pos["key"][1])
			Global.is_opened["cabinet"] = true
			wire.visible = true
		else:
			NotificationManager.show_message("The cabinet is locked", 2.0)
