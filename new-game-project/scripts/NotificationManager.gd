extends Node

var _canvas_layer: CanvasLayer
var _panel: Panel
var _label: Label
var _timer: Timer

# 面板边距（文字与边框之间的距离，可根据喜好调整）
const PADDING = 15   # 左右上下各留 40 像素空白

func _ready():
	# CanvasLayer
	_canvas_layer = CanvasLayer.new()
	_canvas_layer.layer = 100
	add_child(_canvas_layer)
	
	# Panel（初始尺寸随便设，会在 show_message 中重新调整）
	_panel = Panel.new()
	_panel.size = Vector2(200, 80)  # 临时尺寸
	var style_box = StyleBoxFlat.new()
	style_box.bg_color = Color(0.1, 0.1, 0.1, 0.85)
	style_box.corner_radius_top_left = 10
	style_box.corner_radius_top_right = 10
	style_box.corner_radius_bottom_left = 10
	style_box.corner_radius_bottom_right = 10
	_panel.add_theme_stylebox_override("panel", style_box)
	_canvas_layer.add_child(_panel)
	
	# Label
	_label = Label.new()
	_label.horizontal_alignment = HORIZONTAL_ALIGNMENT_CENTER
	_label.vertical_alignment = VERTICAL_ALIGNMENT_CENTER
	_label.add_theme_font_size_override("font_size", 32)
	_label.add_theme_color_override("font_color", Color.WHITE)
	# 先加到面板，再在 show_message 中调整位置
	_panel.add_child(_label)
	
	# 默认隐藏
	_canvas_layer.visible = false
	
	# Timer
	_timer = Timer.new()
	_timer.one_shot = true
	add_child(_timer)
	_timer.timeout.connect(_hide_message)

# ===== 核心函数：显示消息（自动调整尺寸） =====
func show_message(text: String, duration: float = 2.0):
	# 1. 设置文本
	_label.text = text
	
	# 2. 强制更新 Label 的布局，获取其最小尺寸
	# 注意：Label 需要先添加到场景树中才能正确计算，但这里它已经在树里了
	var label_min_size = _label.get_minimum_size()
	
	# 3. 计算面板尺寸（文字尺寸 + 边距）
	var panel_size = Vector2(
		label_min_size.x + PADDING * 2,
		label_min_size.y + PADDING * 2
	)
	_panel.size = panel_size
	
	# 4. 将 Label 放置在面板中心（相对于面板）
	_label.position = Vector2(PADDING, PADDING)
	_label.size = label_min_size  # 设置 label 的大小为最小尺寸，避免文字被截断
	
	# 5. 重新计算面板位置（屏幕居中）
	var screen_size = Vector2(1504,1080)
	_panel.position = Vector2(
		(screen_size.x - panel_size.x) / 2,
		60  # 偏上 50 像素
	)
	
	# 6. 显示
	_canvas_layer.visible = true
	
	# 7. 启动计时器
	_timer.stop()
	_timer.wait_time = duration
	_timer.start()

func _hide_message():
	_canvas_layer.visible = false
