extends Node2D

@export var color_rect: ColorRect
@export var tv: Area2D
@export var ceiling: CanvasLayer



@export var circuit_scene: CanvasLayer
var start_node: Area2D = null   # 记录起点 Area2D
var is_waiting_for_end: bool = false

# 线条容器
var line_container: Node2D

var connections: Array = []


func _ready():
	line_container = Node2D.new()
	line_container.name = "Lines"
	circuit_scene.add_child(line_container)

# 由 Area2D 点击时调用，传入自身，并告诉它是起点还是终点
func register_click(area: Area2D, is_start: bool):
	if is_start:
		# 如果当前还在等待终点，但点击了新的起点，则切换起点
		start_node = area
		is_waiting_for_end = true
		print("起点已设置为：", area.name)
	else:
		# 终点点击
		if start_node != null and is_waiting_for_end:
			connections.append([start_node, area])
			# 生成线条
			_draw_line(start_node.global_position, area.global_position)
			print("生成线条从 ", start_node.name, " 到 ", area.name)
			# 重置状态（一次连线只使用一对，之后可以继续选新起点）
			start_node = null
			is_waiting_for_end = false
		else:
			print("请先选起点！")

func _draw_line(p1: Vector2, p2: Vector2):
	var line = Line2D.new()
	line_container.add_child(line)   # 直接添加到 circuit_scene
	line.z_index = 2
	line.width = 4.0
	line.default_color = Color.YELLOW
	line.antialiased = true
	line.points = [p1, p2]
	print("线条已添加到 circuit_scene，父节点：", line.get_parent())


func clear_all_lines():
	# 删除所有 Line2D 子节点
	for child in line_container.get_children():
		child.queue_free()
	# 清空连接记录
	connections.clear()
	# 重置状态
	start_node = null
	is_waiting_for_end = false
	print("所有线条已清空")
	

# ★ 新增：验证函数（由 Confirm 按钮调用）
func check_answer():
	# 1. 没有任何线 → 直接失败
	if connections.size() == 0:
		NotificationManager.show_message("Line connection error", 2.0)
		print("错误：没有画任何线条！")
		clear_all_lines()
		Global.line_connection_success = false
		return false
	
	# 2. 线的数量超过 1 条 → 失败（不允许多余的线）
	if connections.size() > 1:
		NotificationManager.show_message("Line connection error", 2.0)
		print("错误：连接了多余的线！只能连一条。")
		clear_all_lines()
		Global.line_connection_success = false
		return false
	
	# 3. 恰好只有一条线，检查它是否正确
	var start = connections[0][0]
	var end = connections[0][1]
	
	if start.name == "line_node2" and end.name == "line_node5":
		Global.line_connection_success = true
		NotificationManager.show_message("Line connection success! The power is back on!", 2.0)
		color_rect.visible = false
		var tv_sprite = tv.get_node("Sprite2D")
		tv_sprite.texture = load("res://assets/tv_power_on.png")
		var ceiling_sprite = ceiling.get_node("Sprite2D")
		ceiling_sprite.texture = load("res://assets/ceiling_turned_on.png")
		print("正确！线路连接无误。")
	else:
		Global.line_connection_success = false
		NotificationManager.show_message("Line connection error", 2.0)
		print("错误！线路连接不正确。")
		clear_all_lines()
	
	return Global.line_connection_success
