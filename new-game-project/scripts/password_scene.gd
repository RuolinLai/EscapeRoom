extends Area2D

var password = "9372"
var input: String
@onready var label = $Label
@onready var door = get_node("/root/game/background1/door/Sprite2D")
@export var password_scene: Area2D


func add_digit(num: int):
	input += str(num)
	label.text = input
	
func clear():
	input = ""
	label.text = input

func _input_event(viewport, event, shape_idx):
	if event is InputEventMouseButton and event.pressed and event.button_index == MOUSE_BUTTON_LEFT:
		match shape_idx:
			1:
				add_digit(1)
			2:
				add_digit(2)
			3:
				add_digit(3)
			4:
				add_digit(4)
			5:
				add_digit(5)
			6:
				add_digit(6)
			7:
				add_digit(7)
			8:
				add_digit(8)
			9:
				add_digit(9)
			0:
				add_digit(0)
			10:
				clear()
				print("clear")
			11:
				if input == password:
					print("correct")
					NotificationManager.show_message("Correct!")
					Global.success = true
					clear()
					door.texture = load("res://assets/opened_door.png")
					
				else:
					print("incorrect")
					NotificationManager.show_message("Incorrect!")
					clear()
		get_viewport().set_input_as_handled()
