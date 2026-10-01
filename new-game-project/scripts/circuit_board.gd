extends Area2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
@export var game: Node2D
@export var circuit_scene: CanvasLayer
@onready var up_arrow = get_node("/root/game/up_arrow")
@onready var down_arrow = get_node("/root/game/down_arrow")
@onready var left_arrow = get_node("/root/game/left_arrow")
@onready var right_arrow = get_node("/root/game/right_arrow")


func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if Global.is_clicked["wire"] == true:
			game.use_item(Global.item_pos["wire"][0],Global.item_pos["wire"][1])
			circuit_scene.visible = true
			up_arrow.visible = false
			down_arrow.visible = false
			left_arrow.visible = false
			right_arrow.visible = false
		else:
			NotificationManager.show_message("The circuit board is broken", 2.0)
