extends Area2D

@onready var up_arrow = get_node("/root/game/up_arrow")
@onready var down_arrow = get_node("/root/game/down_arrow")
@onready var left_arrow = get_node("/root/game/left_arrow")
@onready var right_arrow = get_node("/root/game/right_arrow")


func _input_event(viewport, event, shape_idx):
	# 判断是不是鼠标左键点击
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		# 获取父节点（也就是 circuit scene CanvasLayer），把它隐藏
		get_parent().visible = false
		up_arrow.visible = true
		down_arrow.visible = true
		right_arrow.visible = true
		left_arrow.visible = true
