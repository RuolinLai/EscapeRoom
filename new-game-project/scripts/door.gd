extends Area2D

@export var password_scene: Area2D
@export var complete_scene: CanvasLayer
@onready var up_arrow = get_node("/root/game/up_arrow")
@onready var down_arrow = get_node("/root/game/down_arrow")
@onready var left_arrow = get_node("/root/game/left_arrow")
@onready var right_arrow = get_node("/root/game/right_arrow")


func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		if !Global.success:
			password_scene.visible = true
			up_arrow.visible = false
			down_arrow.visible = false
			left_arrow.visible = false
			right_arrow.visible = false
		else:
			complete_scene.visible = true
