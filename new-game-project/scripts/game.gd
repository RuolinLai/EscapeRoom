extends Node2D

var inventory_items = [[null, null], [null, null], [null, null], [null, null], [null, null], [null, null]]

# 背包容器（专门放物品的 2D 节点）
@onready var inventory_container = $InventoryContainer

# ============== 布局参数（根据你的格子调整） ==============
const SLOT_X = 208          # 每个格子宽高
const SLOT_Y = 211
const START_X = 1607            # 第一个格子中心 X 偏移（相对于容器）
const START_Y = 105            # 第一个格子中心 Y 偏移
const COLUMNS = 2
const ROWS = 6


func add_item(item_node: Node2D):
	# 遍历找第一个空格
	for row in range(ROWS):
		for col in range(COLUMNS):
			if inventory_items[row][col] == null:
				# ----- 1. 把物品移到背包容器里 -----
				# 第二个参数 true = 保持世界位置不变（防止瞬移）
				item_node.reparent(inventory_container, true)
				
				# ----- 2. 计算格子中心坐标（相对于 InventoryContainer）-----
				var pos_x = START_X + col * SLOT_X
				var pos_y = START_Y + row * SLOT_Y
				item_node.global_position = Vector2(pos_x, pos_y)
				Global.item_pos[item_node.name] = [row , col]
				
				# ----- 3. 确保碰撞体是激活的（点它！）-----
				if item_node.has_node("CollisionShape2D"):
					item_node.get_node("CollisionShape2D").disabled = false
				
				# ----- 4. 把节点存进数组 -----
				inventory_items[row][col] = item_node
				
				print("物品 ", item_node.name, " 放入背包：行", row, " 列", col)
				return true
	
	print("背包满了！")
	return false

# 使用/取出物品
func use_item(row, col):
	var item = inventory_items[row][col]
	if item == null:
		return false
	item.queue_free()
	
	# 从数组清空
	inventory_items[row][col] = null
	
	
	print("取出物品：", item.name)
	return true
	
#---------------------------------------------------------

# 所有面的名称（顺序索引：0~5）
var face_names = ["background1" , "background2" , "background3" , "background4", "ceiling", "floor"]
var current = 0
# 进入天花板或地板时，记录是从哪面墙进来的（0~3）
var entry_wall = 0

# 墙的固定跳转：上→天花板(4)，下→地板(5)，左/右→相邻墙（循环）
# 对于墙，四个方向的返回值是目标索引
func wall_target(wall_idx, direction):
	match direction:
		"up":   return 4          # 天花板
		"down": return 5          # 地板
		"left": return (wall_idx - 1 + 4) % 4
		"right": return (wall_idx + 1) % 4
	return -1

# 天花板映射表：由入口墙决定四个方向的出口墙（0~3）
var ceiling_map = {
	0: {"up": 2, "down": 0, "left": 3, "right": 1},  # 从 bg1 进入
	1: {"up": 3, "down": 1, "left": 0, "right": 2},  # 从 bg2 进入
	2: {"up": 0, "down": 2, "left": 1, "right": 3},  # 从 bg3 进入
	3: {"up": 1, "down": 3, "left": 2, "right": 0},  # 从 bg4 进入
}

# 地板映射表（这里采用与天花板相同的逻辑，你可以按需修改）
var floor_map = {
	0: {"up": 0, "down": 2, "left": 3, "right": 1},   # 从 bg1 进入
	1: {"up": 1, "down": 3, "left": 0, "right": 2},   # 从 bg2 进入
	2: {"up": 2, "down": 0, "left": 1, "right": 3},   # 从 bg3 进入
	3: {"up": 3, "down": 1, "left": 2, "right": 0},   # 从 bg4 进入
}
# 注意：地板的方向可自由设置，上面的规则是：按上回到入口墙，按下到对面的墙，左右相邻。
@onready var start_scene = get_node("/root/game/start_scene")

func _ready():
	start_scene.visible = true

func move(direction: String):
	var target = -1
	if current < 4:  # 墙
		match direction:
			"up": target = 4
			"down": target = 5
			"left": target = (current - 1 + 4) % 4
			"right": target = (current + 1) % 4
		if target == 4 or target == 5:
			entry_wall = current
	elif current == 4:  # 天花板
		if entry_wall in ceiling_map:
			target = ceiling_map[entry_wall][direction]
	elif current == 5:  # 地板
		if entry_wall in floor_map:
			target = floor_map[entry_wall][direction]
	if target != -1 and target != current:
		switch_to(target)

func _input(event):
	if event is InputEventKey and event.pressed:
		var dir = ""
		match event.keycode:
			KEY_UP: dir = "up"
			KEY_DOWN: dir = "down"
			KEY_LEFT: dir = "left"
			KEY_RIGHT: dir = "right"
		if dir != "":
			move(dir)


func switch_to(new_index):
	# 隐藏当前面
	get_node(face_names[current]).visible = false
	# 显示目标面
	get_node(face_names[new_index]).visible = true
	current = new_index
	# 如果新面是墙，不需要额外操作；如果是天花板/地板，entry_wall 已经记录
	print("当前面：", face_names[current], " (入口墙：", face_names[entry_wall] if current >=4 else "无", ")")
