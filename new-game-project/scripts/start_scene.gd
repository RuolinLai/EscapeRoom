extends Area2D

@onready var dark = get_node("/root/game/ColorRect")
@onready var bg4 = get_node("/root/game/background4")


func _input_event(viewport, event, shape_idx):
	# 判断是不是鼠标左键点击
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		visible = false
		dark.visible = true
		bg4.visible = true
