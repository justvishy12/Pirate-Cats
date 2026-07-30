extends Node2D

#region Occupation Variables
# "wb" "cc" "cb" "e"
#Row 1
@onready var a1 = [$Moveables/WaterBalloon4, "WB"]
@onready var a2 = [$Moveables/Coconut4, "CC"]
@onready var a3 = [$Moveables/WaterBalloon3, "WB"]
@onready var a4 = [$Moveables/CannonBall3, "CB"]
#Row 2
@onready var b1 = [$Moveables/Coconut3, "CC"]
@onready var b2 = [$Moveables/Coconut2, "CC"]
@onready var b3 = [$Moveables/CannonBall2, "CB"]
@onready var b4 = [$Moveables/Coconut1, "CC"]
#Row 3
@onready var c1 = [$Moveables/CannonBall4, "CB"]
@onready var c2 = [$Moveables/WaterBalloon2, "WB"]
@onready var c3 = [$Moveables/WaterBalloon1, "WB"]
@onready var c4 = [$Moveables/CannonBall1, "CB"]
#Row 4
@onready var d1 = [$Empty, "E"]
@onready var d2 = [$Empty, "E"]
@onready var d3 = [$Empty, "E"]
@onready var d4 = [$Empty, "E"]
#endregion

#region Moving Variables
#Row 1
var Ma1 = false
var Ma2 = false
var Ma3 = false
var Ma4 = false
#Row 2
var Mb1 = false
var Mb2 = false
var Mb3 = false
var Mb4 = false
#Row 3
var Mc1 = false
var Mc2 = false
var Mc3 = false
var Mc4 = false
#Row 4
var Md1 = false
var Md2 = false
var Md3 = false
var Md4 = false
#endregion

#region Positions
var a1_pos = Vector2(45, 278)
var a2_pos = Vector2(45, 338)
var a3_pos = Vector2(45, 398)
var a4_pos = Vector2(45, 458)
var b1_pos = Vector2(184, 278)
var b2_pos = Vector2(184, 338)
var b3_pos = Vector2(184, 398)
var b4_pos = Vector2(184, 458)
var c1_pos = Vector2(320, 278)
var c2_pos = Vector2(320, 338)
var c3_pos = Vector2(320, 398)
var c4_pos = Vector2(320, 458)
var d1_pos = Vector2(458, 278)
var d2_pos = Vector2(458, 338)
var d3_pos = Vector2(458, 398)
var d4_pos = Vector2(458, 458)
#endregion

#region Dragging
var dragginga1 = false
var ofa1 = Vector2(0,0)
var in_zonea1 = false
var dragginga2 = false
var ofa2 = Vector2(0,0)
var in_zonea2 = false
var dragginga3 = false
var ofa3 = Vector2(0,0)
var in_zonea3 = false
var dragginga4 = false
var ofa4 = Vector2(0,0)
var in_zonea4 = false

var draggingb1 = false
var ofb1 = Vector2(0,0)
var in_zoneb1 = false
var draggingb2 = false
var ofb2 = Vector2(0,0)
var in_zoneb2 = false
var draggingb3 = false
var ofb3 = Vector2(0,0)
var in_zoneb3 = false
var draggingb4 = false
var ofb4 = Vector2(0,0)
var in_zoneb4 = false

var draggingc1 = false
var ofc1 = Vector2(0,0)
var in_zonec1 = false
var draggingc2 = false
var ofc2 = Vector2(0,0)
var in_zonec2 = false
var draggingc3 = false
var ofc3 = Vector2(0,0)
var in_zonec3 = false
var draggingc4 = false
var ofc4 = Vector2(0,0)
var in_zonec4 = false

var draggingd1 = false
var ofd1 = Vector2(0,0)
var in_zoned1 = false
var draggingd2 = false
var ofd2 = Vector2(0,0)
var in_zoned2 = false
var draggingd3 = false
var ofd3 = Vector2(0,0)
var in_zoned3 = false
var draggingd4 = false
var ofd4 = Vector2(0,0)
var in_zoned4 = false
#endregion
@onready var Buttons = [$Buttons/A1, $Buttons/A2,$Buttons/A3,$Buttons/A4,$Buttons/B1,$Buttons/B2,$Buttons/B3,$Buttons/B4,$Buttons/C1,$Buttons/C2,$Buttons/C3,$Buttons/C4,$Buttons/D1,$Buttons/D2,$Buttons/D3,$Buttons/D4]
var wb4 = false
var cc4 = false
var cb4 = false
var finish = false

var map_dialogue_shown = false
var dialogue = [
	{
		#0
		"speaker": "cat",
		"name": "Smokey (Powder Monkey)",
		"text": "Who actually organized these cannons! ",
		"portrait": preload("res://assets/headshots/POWDER MONKEY FACE.png")
	},
	{
		#1
		"speaker": "you",
		"name": "",
		"text": "How should I help? "
	},
	{
		#2
		"speaker": "cat",
		"name": "Smokey (Powder Monkey)",
		"text": "Drag items from cannon to cannon until each cannon only has 1 type of item. ",
		"portrait": preload("res://assets/headshots/POWDER MONKEY FACE.png")
	},

	{ 
		#3
		"speaker": "cat",
		"name": "Smokey (Powder Monkey)",
		"text": "Wait, is that? Thank you so much, leave it on the captains desk! ",
		"portrait": preload("res://assets/headshots/POWDER MONKEY FACE.png")
	},
]

var dialogue_index = 0
var typing = false



func show_next_dialogue() -> void:
	if dialogue_index >= dialogue.size():
		$Textbox.visible = false
		$"player button".visible = false
		return
	
	var line = dialogue[dialogue_index]
	
	if line["speaker"] == "you":
		$Textbox.visible = false
		$"player button".visible = true
		$"player button".text = line["text"]
		
	elif line["speaker"] == "cat":
		$"player button".visible = false
		show_cat_text(line)

		

func _on_player_button_pressed() -> void:
	dialogue_index += 1
	show_next_dialogue()

func show_cat_text(line) -> void:
	$Textbox.visible = true
	typing = true
	
	$Textbox/namelabel.text = line["name"]
	$Textbox/textlabel.text = line["text"]
	
	if line.has("portrait"):
		$Textbox/photobox.texture = line["portrait"]
	else:
		$Textbox/photobox.texture = null
	$Textbox/textlabel.visible_characters = 0
	
	for i in $Textbox/textlabel.text.length():
		if !is_inside_tree():
			return
		$Textbox/textlabel.visible_characters = i
		await get_tree().create_timer(SaveManager.speed, false).timeout
	
	typing = false


func _input(event):
	if event.is_action_pressed("ui_accept") and !typing:
		if dialogue_index < dialogue.size() and dialogue[dialogue_index]["speaker"] == "cat":
			if dialogue_index == 2:
				print("Hiding panel")
				$Textbox.visible = false
				$Panel.visible = false
			if dialogue_index == 3:
				get_tree().change_scene_to_file("res://scene/SideShipView1.tscn")
			if dialogue_index != 2:
				dialogue_index += 1
				show_next_dialogue()
			
		
		
func _on_mapbutton_pressed() -> void:
	if map_dialogue_shown == false:
		map_dialogue_shown = true
		dialogue_index = 3
		show_next_dialogue()

func _ready() -> void:
	show_next_dialogue()
	$mapbutton.modulate.a = 0.0
	$mapbutton.visible = false

func _process(delta: float) -> void:
	if a1[1] == "WB" and a2[1] == "WB" and a3[1] == "WB" and a4[1] == "WB":
		wb4 = true
	elif b1[1] == "WB" and b2[1] == "WB" and b3[1] == "WB" and b4[1] == "WB":
		wb4 = true
	elif c1[1] == "WB" and c2[1] == "WB" and c3[1] == "WB" and c4[1] == "WB":
		wb4 = true
	elif d1[1] == "WB" and d2[1] == "WB" and d3[1] == "WB" and d4[1] == "WB":
		wb4 = true
		
	if a1[1] == "CC" and a2[1] == "CC" and a3[1] == "CC" and a4[1] == "CC":
		cc4 = true
	elif b1[1] == "CC" and b2[1] == "CC" and b3[1] == "CC" and b4[1] == "CC":
		cc4 = true
	elif c1[1] == "CC" and c2[1] == "CC" and c3[1] == "CC" and c4[1] == "CC":
		cc4 = true
	elif d1[1] == "CC" and d2[1] == "CC" and d3[1] == "CC" and d4[1] == "CC":
		cc4 = true
		
	if a1[1] == "CB" and a2[1] == "CB" and a3[1] == "CB" and a4[1] == "CB":
		cb4 = true
	elif b1[1] == "CB" and b2[1] == "CB" and b3[1] == "CB" and b4[1] == "CB":
		cb4 = true
	elif c1[1] == "CB" and c2[1] == "CB" and c3[1] == "CB" and c4[1] == "CB":
		cb4 = true
	elif d1[1] == "CB" and d2[1] == "CB" and d3[1] == "CB" and d4[1] == "CB":
		cb4 = true
		
	if cb4 == true and cc4 == true and wb4 == true and finish == false:
		finish = true
		SaveManager.sort = true
		SaveManager.save_game(SaveManager.current_slot)
		for button in Buttons:
			button.disabled = true
		$mapbutton.visible = true
		var tween = create_tween()
		tween.tween_property($mapbutton, "modulate:a", 1.0, 0.5)
		

#region Dragging
	if dragginga1:
		a1[0].global_position = get_global_mouse_position() - ofa1
	if dragginga2:
		a2[0].global_position = get_global_mouse_position() - ofa2
	if dragginga3:
		a3[0].global_position = get_global_mouse_position() - ofa3
	if dragginga4:
		a4[0].global_position = get_global_mouse_position() - ofa4
	if draggingb1:
		b1[0].global_position = get_global_mouse_position() - ofb1
	if draggingb2:
		b2[0].global_position = get_global_mouse_position() - ofb2
	if draggingb3:
		b3[0].global_position = get_global_mouse_position() - ofb3
	if draggingb4:
		b4[0].global_position = get_global_mouse_position() - ofb4
	if draggingc1:
		c1[0].global_position = get_global_mouse_position() - ofc1
	if draggingc2:
		c2[0].global_position = get_global_mouse_position() - ofc2
	if draggingc3:
		c3[0].global_position = get_global_mouse_position() - ofc3
	if draggingc4:
		c4[0].global_position = get_global_mouse_position() - ofc4
	if draggingd1:
		d1[0].global_position = get_global_mouse_position() - ofd1
	if draggingd2:
		d2[0].global_position = get_global_mouse_position() - ofd2
	if draggingd3:
		d3[0].global_position = get_global_mouse_position() - ofd3
	if draggingd4:
		d4[0].global_position = get_global_mouse_position() - ofd4
#endregion





#region Buttons Down

func _on_a_1_button_down() -> void:
	if a1[0] != $Empty:
		dragginga1 = true
		ofa1 = get_global_mouse_position() - a1[0].global_position


func _on_a_2_button_down() -> void:
	if a2[0] != $Empty and a1[0] == $Empty:
		dragginga2 = true
		ofa2 = get_global_mouse_position() - a2[0].global_position


func _on_a_3_button_down() -> void:
	if a3[0] != $Empty and a2[0] == $Empty:
		dragginga3 = true
		ofa3 = get_global_mouse_position() - a3[0].global_position


func _on_a_4_button_down() -> void:
	if a4[0] != $Empty and a3[0] == $Empty:
		dragginga4 = true
		ofa4 = get_global_mouse_position() - a4[0].global_position


func _on_b_1_button_down() -> void:
	if b1[0] != $Empty :
		draggingb1 = true
		ofb1 = get_global_mouse_position() - b1[0].global_position


func _on_b_2_button_down() -> void:
	if b2[0] != $Empty and b1[0] == $Empty:
		draggingb2 = true
		ofb2 = get_global_mouse_position() - b2[0].global_position


func _on_b_3_button_down() -> void:
	if b3[0] != $Empty and b2[0] == $Empty:
		draggingb3 = true
		ofb3 = get_global_mouse_position() - b3[0].global_position


func _on_b_4_button_down() -> void:
	if b4[0] != $Empty and b3[0] == $Empty:
		draggingb4 = true
		ofb4 = get_global_mouse_position() - b4[0].global_position


func _on_c_1_button_down() -> void:
	if c1[0] != $Empty:
		draggingc1 = true
		ofc1 = get_global_mouse_position() - c1[0].global_position


func _on_c_2_button_down() -> void:
	if c2[0] != $Empty and c1[0] == $Empty:
		draggingc2 = true
		ofc2 = get_global_mouse_position() - c2[0].global_position


func _on_c_3_button_down() -> void:
	if c3[0] != $Empty and c2[0] == $Empty:
		draggingc3 = true
		ofc3 = get_global_mouse_position() - c3[0].global_position


func _on_c_4_button_down() -> void:
	if c4[0] != $Empty and c3[0] == $Empty:
		draggingc4 = true
		ofc4 = get_global_mouse_position() - c4[0].global_position


func _on_d_1_button_down() -> void:
	if d1[0] != $Empty:
		draggingd1 = true
		ofd1 = get_global_mouse_position() - d1[0].global_position


func _on_d_2_button_down() -> void:
	if d2[0] != $Empty and d1[0] == $Empty:
		draggingd2 = true
		ofd2 = get_global_mouse_position() - d2[0].global_position


func _on_d_3_button_down() -> void:
	if d3[0] != $Empty and d2[0] == $Empty:
		draggingd3 = true
		ofd3 = get_global_mouse_position() - d3[0].global_position


func _on_d_4_button_down() -> void:
	if d4[0] != $Empty and d3[0] == $Empty:
		draggingd4 = true
		ofd4 = get_global_mouse_position() - d4[0].global_position
#endregion


#region Buttons Up
func _on_a_1_button_up() -> void:
	dragginga1 = false
	if a1[1] == "E":
		pass
	elif a1[0].get_node("MoveablePanel").get_global_rect().intersects($Row2.get_global_rect()):
		if b4[0] == $Empty:
			b4[0] = a1[0]
			b4[1] = a1[1]
			a1[0] = $Empty
			a1[1] = "E"
			b4[0].position = b4_pos
		elif b3[0] == $Empty:
			b3[0] = a1[0]
			b3[1] = a1[1]
			a1[0] = $Empty
			a1[1] = "E"
			b3[0].position = b3_pos
		elif b2[0] == $Empty:
			b2[0] = a1[0]
			b2[1] = a1[1]
			a1[0] = $Empty
			a1[1] = "E"
			b2[0].position = b2_pos
		elif b1[0] == $Empty:
			b1[0] = a1[0]
			b1[1] = a1[1]
			a1[0] = $Empty
			a1[1] = "E"
			b1[0].position = b1_pos
		else:
			a1[0].position = a1_pos
	elif a1[0].get_node("MoveablePanel").get_global_rect().intersects($Row3.get_global_rect()):
		if c4[0] == $Empty:
			c4[0] = a1[0]
			c4[1] = a1[1]
			a1[0] = $Empty
			a1[1] = "E"
			c4[0].position = c4_pos
		elif c3[0] == $Empty:
			c3[0] = a1[0]
			c3[1] = a1[1]
			a1[0] = $Empty
			a1[1] = "E"
			c3[0].position = c3_pos
		elif c2[0] == $Empty:
			c2[0] = a1[0]
			c2[1] = a1[1]
			a1[0] = $Empty
			a1[1] = "E"
			c2[0].position = c2_pos
		elif c1[0] == $Empty:
			c1[0] = a1[0]
			c1[1] = a1[1]
			a1[0] = $Empty
			a1[1] = "E"
			c1[0].position = c1_pos
		else:
			a1[0].position = a1_pos
	elif a1[0].get_node("MoveablePanel").get_global_rect().intersects($Row4.get_global_rect()):
		if d4[0] == $Empty:
			d4[0] = a1[0]
			d4[1] = a1[1]
			a1[0] = $Empty
			a1[1] = "E"
			d4[0].position = d4_pos
		elif d3[0] == $Empty:
			d3[0] = a1[0]
			d3[1] = a1[1]
			a1[0] = $Empty
			a1[1] = "E"
			d3[0].position = d3_pos
		elif d2[0] == $Empty:
			d2[0] = a1[0]
			d2[1] = a1[1]
			a1[0] = $Empty
			a1[1] = "E"
			d2[0].position = d2_pos
		elif d1[0] == $Empty:
			d1[0] = a1[0]
			d1[1] = a1[1]
			a1[0] = $Empty
			a1[1] = "E"
			d1[0].position = d1_pos
		else:
			a1[0].position = a1_pos
	else:
		a1[0].position = a1_pos

func _on_a_2_button_up() -> void:
	dragginga2 = false
	if a2[1] == "E":
		pass
	elif a2[0].get_node("MoveablePanel").get_global_rect().intersects($Row2.get_global_rect()):
		if b4[0] == $Empty:
			b4[0] = a2[0]
			b4[1] = a2[1]
			a2[0] = $Empty
			a2[1] = "E"
			b4[0].position = b4_pos
		elif b3[0] == $Empty:
			b3[0] = a2[0]
			b3[1] = a2[1]
			a2[0] = $Empty
			a2[1] = "E"
			b3[0].position = b3_pos
		elif b2[0] == $Empty:
			b2[0] = a2[0]
			b2[1] = a2[1]
			a2[0] = $Empty
			a2[1] = "E"
			b2[0].position = b2_pos
		elif b1[0] == $Empty:
			b1[0] = a2[0]
			b1[1] = a2[1]
			a2[0] = $Empty
			a2[1] = "E"
			b1[0].position = b1_pos
		else:
			a2[0].position = a2_pos
	elif a2[0].get_node("MoveablePanel").get_global_rect().intersects($Row3.get_global_rect()):
		if c4[0] == $Empty:
			c4[0] = a2[0]
			c4[1] = a2[1]
			a2[0] = $Empty
			a2[1] = "E"
			c4[0].position = c4_pos
		elif c3[0] == $Empty:
			c3[0] = a2[0]
			c3[1] = a2[1]
			a2[0] = $Empty
			a2[1] = "E"
			c3[0].position = c3_pos
		elif c2[0] == $Empty:
			c2[0] = a2[0]
			c2[1] = a2[1]
			a2[0] = $Empty
			a2[1] = "E"
			c2[0].position = c2_pos
		elif c1[0] == $Empty:
			c1[0] = a2[0]
			c1[1] = a2[1]
			a2[0] = $Empty
			a2[1] = "E"
			c1[0].position = c1_pos
		else:
			a2[0].position = a2_pos
	elif a2[0].get_node("MoveablePanel").get_global_rect().intersects($Row4.get_global_rect()):
		if d4[0] == $Empty:
			d4[0] = a2[0]
			d4[1] = a2[1]
			a2[0] = $Empty
			a2[1] = "E"
			d4[0].position = d4_pos
		elif d3[0] == $Empty:
			d3[0] = a2[0]
			d3[1] = a2[1]
			a2[0] = $Empty
			a2[1] = "E"
			d3[0].position = d3_pos
		elif d2[0] == $Empty:
			d2[0] = a2[0]
			d2[1] = a2[1]
			a2[0] = $Empty
			a2[1] = "E"
			d2[0].position = d2_pos
		elif d1[0] == $Empty:
			d1[0] = a2[0]
			d1[1] = a2[1]
			a2[0] = $Empty
			a2[1] = "E"
			d1[0].position = d1_pos
		else:
			a2[0].position = a2_pos
	else:
		a2[0].position = a2_pos

func _on_a_3_button_up() -> void:
	dragginga3 = false
	if a3[1] == "E":
		pass
	elif a3[0].get_node("MoveablePanel").get_global_rect().intersects($Row2.get_global_rect()):
		if b4[0] == $Empty:
			b4[0] = a3[0]
			b4[1] = a3[1]
			a3[0] = $Empty
			a3[1] = "E"
			b4[0].position = b4_pos
		elif b3[0] == $Empty:
			b3[0] = a3[0]
			b3[1] = a3[1]
			a3[0] = $Empty
			a3[1] = "E"
			b3[0].position = b3_pos
		elif b2[0] == $Empty:
			b2[0] = a3[0]
			b2[1] = a3[1]
			a3[0] = $Empty
			a3[1] = "E"
			b2[0].position = b2_pos
		elif b1[0] == $Empty:
			b1[0] = a3[0]
			b1[1] = a3[1]
			a3[0] = $Empty
			a3[1] = "E"
			b1[0].position = b1_pos
		else:
			a3[0].position = a3_pos
	elif a3[0].get_node("MoveablePanel").get_global_rect().intersects($Row3.get_global_rect()):
		if c4[0] == $Empty:
			c4[0] = a3[0]
			c4[1] = a3[1]
			a3[0] = $Empty
			a3[1] = "E"
			c4[0].position = c4_pos
		elif c3[0] == $Empty:
			c3[0] = a3[0]
			c3[1] = a3[1]
			a3[0] = $Empty
			a3[1] = "E"
			c3[0].position = c3_pos
		elif c2[0] == $Empty:
			c2[0] = a3[0]
			c2[1] = a3[1]
			a3[0] = $Empty
			a3[1] = "E"
			c2[0].position = c2_pos
		elif c1[0] == $Empty:
			c1[0] = a3[0]
			c1[1] = a3[1]
			a3[0] = $Empty
			a3[1] = "E"
			c1[0].position = c1_pos
		else:
			a3[0].position = a3_pos
	elif a3[0].get_node("MoveablePanel").get_global_rect().intersects($Row4.get_global_rect()):
		if d4[0] == $Empty:
			d4[0] = a3[0]
			d4[1] = a3[1]
			a3[0] = $Empty
			a3[1] = "E"
			d4[0].position = d4_pos
		elif d3[0] == $Empty:
			d3[0] = a3[0]
			d3[1] = a3[1]
			a3[0] = $Empty
			a3[1] = "E"
			d3[0].position = d3_pos
		elif d2[0] == $Empty:
			d2[0] = a3[0]
			d2[1] = a3[1]
			a3[0] = $Empty
			a3[1] = "E"
			d2[0].position = d2_pos
		elif d1[0] == $Empty:
			d1[0] = a3[0]
			d1[1] = a3[1]
			a3[0] = $Empty
			a3[1] = "E"
			d1[0].position = d1_pos
		else:
			a3[0].position = a3_pos
	else:
		a3[0].position = a3_pos

func _on_a_4_button_up() -> void:
	dragginga4 = false
	if a4[1] == "E":
		pass
	elif a4[0].get_node("MoveablePanel").get_global_rect().intersects($Row2.get_global_rect()):
		if b4[0] == $Empty:
			b4[0] = a4[0]
			b4[1] = a4[1]
			a4[0] = $Empty
			a4[1] = "E"
			b4[0].position = b4_pos
		elif b3[0] == $Empty:
			b3[0] = a4[0]
			b3[1] = a4[1]
			a4[0] = $Empty
			a4[1] = "E"
			b3[0].position = b3_pos
		elif b2[0] == $Empty:
			b2[0] = a4[0]
			b2[1] = a4[1]
			a4[0] = $Empty
			a4[1] = "E"
			b2[0].position = b2_pos
		elif b1[0] == $Empty:
			b1[0] = a4[0]
			b1[1] = a4[1]
			a4[0] = $Empty
			a4[1] = "E"
			b1[0].position = b1_pos
		else:
			a4[0].position = a4_pos
	elif a4[0].get_node("MoveablePanel").get_global_rect().intersects($Row3.get_global_rect()):
		if c4[0] == $Empty:
			c4[0] = a4[0]
			c4[1] = a4[1]
			a4[0] = $Empty
			a4[1] = "E"
			c4[0].position = c4_pos
		elif c3[0] == $Empty:
			c3[0] = a4[0]
			c3[1] = a4[1]
			a4[0] = $Empty
			a4[1] = "E"
			c3[0].position = c3_pos
		elif c2[0] == $Empty:
			c2[0] = a4[0]
			c2[1] = a4[1]
			a4[0] = $Empty
			a4[1] = "E"
			c2[0].position = c2_pos
		elif c1[0] == $Empty:
			c1[0] = a4[0]
			c1[1] = a4[1]
			a4[0] = $Empty
			a4[1] = "E"
			c1[0].position = c1_pos
		else:
			a4[0].position = a4_pos
	elif a4[0].get_node("MoveablePanel").get_global_rect().intersects($Row4.get_global_rect()):
		if d4[0] == $Empty:
			d4[0] = a4[0]
			d4[1] = a4[1]
			a4[0] = $Empty
			a4[1] = "E"
			d4[0].position = d4_pos
		elif d3[0] == $Empty:
			d3[0] = a4[0]
			d3[1] = a4[1]
			a4[0] = $Empty
			a4[1] = "E"
			d3[0].position = d3_pos
		elif d2[0] == $Empty:
			d2[0] = a4[0]
			d2[1] = a4[1]
			a4[0] = $Empty
			a4[1] = "E"
			d2[0].position = d2_pos
		elif d1[0] == $Empty:
			d1[0] = a4[0]
			d1[1] = a4[1]
			a4[0] = $Empty
			a4[1] = "E"
			d1[0].position = d1_pos
		else:
			a4[0].position = a4_pos
	else:
		a4[0].position = a4_pos


func _on_b_1_button_up() -> void:
	draggingb1 = false
	if b1[1] == "E":
		pass
	elif b1[0].get_node("MoveablePanel").get_global_rect().intersects($Row1.get_global_rect()):
		if a4[0] == $Empty:
			a4[0] = b1[0]
			a4[1] = b1[1]
			b1[0] = $Empty
			b1[1] = "E"
			a4[0].position = a4_pos
		elif a3[0] == $Empty:
			a3[0] = b1[0]
			a3[1] = b1[1]
			b1[0] = $Empty
			b1[1] = "E"
			a3[0].position = a3_pos
		elif a2[0] == $Empty:
			a2[0] = b1[0]
			a2[1] = b1[1]
			b1[0] = $Empty
			b1[1] = "E"
			a2[0].position = a2_pos
		elif a1[0] == $Empty:
			a1[0] = b1[0]
			a1[1] = b1[1]
			b1[0] = $Empty
			b1[1] = "E"
			a1[0].position = a1_pos
		else:
			b1[0].position = b1_pos
	elif b1[0].get_node("MoveablePanel").get_global_rect().intersects($Row3.get_global_rect()):
		if c4[0] == $Empty:
			c4[0] = b1[0]
			c4[1] = b1[1]
			b1[0] = $Empty
			b1[1] = "E"
			c4[0].position = c4_pos
		elif c3[0] == $Empty:
			c3[0] = b1[0]
			c3[1] = b1[1]
			b1[0] = $Empty
			b1[1] = "E"
			c3[0].position = c3_pos
		elif c2[0] == $Empty:
			c2[0] = b1[0]
			c2[1] = b1[1]
			b1[0] = $Empty
			b1[1] = "E"
			c2[0].position = c2_pos
		elif c1[0] == $Empty:
			c1[0] = b1[0]
			c1[1] = b1[1]
			b1[0] = $Empty
			b1[1] = "E"
			c1[0].position = c1_pos
		else:
			b1[0].position = b1_pos
	elif b1[0].get_node("MoveablePanel").get_global_rect().intersects($Row4.get_global_rect()):
		if d4[0] == $Empty:
			d4[0] = b1[0]
			d4[1] = b1[1]
			b1[0] = $Empty
			b1[1] = "E"
			d4[0].position = d4_pos
		elif d3[0] == $Empty:
			d3[0] = b1[0]
			d3[1] = b1[1]
			b1[0] = $Empty
			b1[1] = "E"
			d3[0].position = d3_pos
		elif d2[0] == $Empty:
			d2[0] = b1[0]
			d2[1] = b1[1]
			b1[0] = $Empty
			b1[1] = "E"
			d2[0].position = d2_pos
		elif d1[0] == $Empty:
			d1[0] = b1[0]
			d1[1] = b1[1]
			b1[0] = $Empty
			b1[1] = "E"
			d1[0].position = d1_pos
		else :
			b1[0].position = b1_pos
	else:
		b1[0].position = b1_pos

func _on_b_2_button_up() -> void:
	draggingb2 = false
	if b2[1] == "E":
		pass
	elif b2[0].get_node("MoveablePanel").get_global_rect().intersects($Row1.get_global_rect()):
		print("r1")
		if a4[0] == $Empty:
			a4[0] = b2[0]
			a4[1] = b2[1]
			b2[0] = $Empty
			b2[1] = "E"
			a4[0].position = a4_pos
		elif a3[0] == $Empty:
			a3[0] = b2[0]
			a3[1] = b2[1]
			b2[0] = $Empty
			b2[1] = "E"
			a3[0].position = a3_pos
		elif a2[0] == $Empty:
			a2[0] = b2[0]
			a2[1] = b2[1]
			b2[0] = $Empty
			b2[1] = "E"
			a2[0].position = a2_pos
		elif a1[0] == $Empty:
			a1[0] = b2[0]
			a1[1] = b2[1]
			b2[0] = $Empty
			b2[1] = "E"
			a1[0].position = a1_pos
		else :
			b2[0].position = b2_pos
	elif b2[0].get_node("MoveablePanel").get_global_rect().intersects($Row3.get_global_rect()):
		print("r3")
		if c4[0] == $Empty:
			c4[0] = b2[0]
			c4[1] = b2[1]
			b2[0] = $Empty
			b2[1] = "E"
			c4[0].position = c4_pos
		elif c3[0] == $Empty:
			c3[0] = b2[0]
			c3[1] = b2[1]
			b2[0] = $Empty
			b2[1] = "E"
			c3[0].position = c3_pos
		elif c2[0] == $Empty:
			c2[0] = b2[0]
			c2[1] = b2[1]
			b2[0] = $Empty
			b2[1] = "E"
			c2[0].position = c2_pos
		elif c1[0] == $Empty:
			c1[0] = b2[0]
			c1[1] = b2[1]
			b2[0] = $Empty
			b2[1] = "E"
			c1[0].position = c1_pos
		else :
			b2[0].position = b2_pos
	elif b2[0].get_node("MoveablePanel").get_global_rect().intersects($Row4.get_global_rect()):
		if d4[0] == $Empty:
			d4[0] = b2[0]
			d4[1] = b2[1]
			b2[0] = $Empty
			b2[1] = "E"
			d4[0].position = d4_pos
		elif d3[0] == $Empty:
			d3[0] = b2[0]
			d3[1] = b2[1]
			b2[0] = $Empty
			b2[1] = "E"
			d3[0].position = d3_pos
		elif d2[0] == $Empty:
			d2[0] = b2[0]
			d2[1] = b2[1]
			b2[0] = $Empty
			b2[1] = "E"
			d2[0].position = d2_pos
		elif d1[0] == $Empty:
			d1[0] = b2[0]
			d1[1] = b2[1]
			b2[0] = $Empty
			b2[1] = "E"
			d1[0].position = d1_pos
		else :
			b2[0].position = b2_pos
	else:
		b2[0].position = b2_pos

func _on_b_3_button_up() -> void:
	draggingb3 = false
	if b3[1] == "E":
		pass
	elif b3[0].get_node("MoveablePanel").get_global_rect().intersects($Row1.get_global_rect()):
		if a4[0] == $Empty:
			a4[0] = b3[0]
			a4[1] = b3[1]
			b3[0] = $Empty
			b3[1] = "E"
			a4[0].position = a4_pos
		elif a3[0] == $Empty:
			a3[0] = b3[0]
			a3[1] = b3[1]
			b3[0] = $Empty
			b3[1] = "E"
			a3[0].position = a3_pos
		elif a2[0] == $Empty:
			a2[0] = b3[0]
			a2[1] = b3[1]
			b3[0] = $Empty
			b3[1] = "E"
			a2[0].position = a2_pos
		elif a1[0] == $Empty:
			a1[0] = b3[0]
			a1[1] = b3[1]
			b3[0] = $Empty
			b3[1] = "E"
			a1[0].position = a1_pos
		else :
			b3[1].position = b1_pos
	elif b3[0].get_node("MoveablePanel").get_global_rect().intersects($Row3.get_global_rect()):
		if c4[0] == $Empty:
			c4[0] = b3[0]
			c4[1] = b3[1]
			b3[0] = $Empty
			b3[1] = "E"
			c4[0].position = c4_pos
		elif c3[0] == $Empty:
			c3[0] = b3[0]
			c3[1] = b3[1]
			b3[0] = $Empty
			b3[1] = "E"
			c3[0].position = c3_pos
		elif c2[0] == $Empty:
			c2[0] = b3[0]
			c2[1] = b3[1]
			b3[0] = $Empty
			b3[1] = "E"
			c2[0].position = c2_pos
		elif c1[0] == $Empty:
			c1[0] = b3[0]
			c1[1] = b3[1]
			b3[0] = $Empty
			b3[1] = "E"
			c1[0].position = c1_pos
		else :
			b3[1].position = b1_pos
	elif b3[0].get_node("MoveablePanel").get_global_rect().intersects($Row4.get_global_rect()):
		if d4[0] == $Empty:
			d4[0] = b3[0]
			d4[1] = b3[1]
			b3[0] = $Empty
			b3[1] = "E"
			d4[0].position = d4_pos
		elif d3[0] == $Empty:
			d3[0] = b3[0]
			d3[1] = b3[1]
			b3[0] = $Empty
			b3[1] = "E"
			d3[0].position = d3_pos
		elif d2[0] == $Empty:
			d2[0] = b3[0]
			d2[1] = b3[1]
			b3[0] = $Empty
			b3[1] = "E"
			d2[0].position = d2_pos
		elif d1[0] == $Empty:
			d1[0] = b3[0]
			d1[1] = b3[1]
			b3[0] = $Empty
			b3[1] = "E"
			d1[0].position = d1_pos
		else :
			b3[1].position = b1_pos
	else:
		b3[0].position = b3_pos

func _on_b_4_button_up() -> void:
	draggingb4 = false
	if b4[1] == "E":
		pass
	elif b4[0].get_node("MoveablePanel").get_global_rect().intersects($Row1.get_global_rect()):
		if a4[0] == $Empty:
			a4[0] = b4[0]
			a4[1] = b4[1]
			b4[0] = $Empty
			b4[1] = "E"
			a4[0].position = a4_pos
		elif a3[0] == $Empty:
			a3[0] = b4[0]
			a3[1] = b4[1]
			b4[0] = $Empty
			b4[1] = "E"
			a3[0].position = a3_pos
		elif a2[0] == $Empty:
			a2[0] = b4[0]
			a2[1] = b4[1]
			b4[0] = $Empty
			b4[1] = "E"
			a2[0].p7osition = a2_pos
		elif a1[0] == $Empty:
			a1[0] = b4[0]
			a1[1] = b4[1]
			b4[0] = $Empty
			b4[1] = "E"
			a1[0].position = a1_pos
		else:
			b4[0].position = b4_pos
	elif b4[0].get_node("MoveablePanel").get_global_rect().intersects($Row3.get_global_rect()):
		if c4[0] == $Empty:
			c4[0] = b4[0]
			c4[1] = b4[1]
			b4[0] = $Empty
			b4[1] = "E"
			c4[0].position = c4_pos
		elif c3[0] == $Empty:
			c3[0] = b4[0]
			c3[1] = b4[1]
			b4[0] = $Empty
			b4[1] = "E"
			c3[0].position = c3_pos
		elif c2[0] == $Empty:
			c2[0] = b4[0]
			c2[1] = b4[1]
			b4[0] = $Empty
			b4[1] = "E"
			c2[0].position = c2_pos
		elif c1[0] == $Empty:
			c1[0] = b4[0]
			c1[1] = b4[1]
			b4[0] = $Empty
			b4[1] = "E"
			c1[0].position = c1_pos
		else:
			b4[0].position = b4_pos
	elif b4[0].get_node("MoveablePanel").get_global_rect().intersects($Row4.get_global_rect()):
		if d4[0] == $Empty:
			d4[0] = b4[0]
			d4[1] = b4[1]
			b4[0] = $Empty
			b4[1] = "E"
			d4[0].position = d4_pos
		elif d3[0] == $Empty:
			d3[0] = b4[0]
			d3[1] = b4[1]
			b4[0] = $Empty
			b4[1] = "E"
			d3[0].position = d3_pos
		elif d2[0] == $Empty:
			d2[0] = b4[0]
			d2[1] = b4[1]
			b4[0] = $Empty
			b4[1] = "E"
			d2[0].position = d2_pos
		elif d1[0] == $Empty:
			d1[0] = b4[0]
			d1[1] = b4[1]
			b4[0] = $Empty
			b4[1] = "E"
			d1[0].position = d1_pos
		else:
			b4[0].position = b4_pos
		
		
	else:
		b4[0].position = b4_pos



func _on_c_1_button_up() -> void:
	draggingc1 = false
	if c1[1] == "E":
		pass
	elif c1[0].get_node("MoveablePanel").get_global_rect().intersects($Row1.get_global_rect()):
		if a4[0] == $Empty:
			a4[0] = c1[0]
			a4[1] = c1[1]
			c1[0] = $Empty
			c1[1] = "E"
			a4[0].position = a4_pos
		elif a3[0] == $Empty:
			a3[0] = c1[0]
			a3[1] = c1[1]
			c1[0] = $Empty
			c1[1] = "E"
			a3[0].position = a3_pos
		elif a2[0] == $Empty:
			a2[0] = c1[0]
			a2[1] = c1[1]
			c1[0] = $Empty
			c1[1] = "E"
			a2[0].position = a2_pos
		elif a1[0] == $Empty:
			a1[0] = c1[0]
			a1[1] = c1[1]
			c1[0] = $Empty
			c1[1] = "E"
			a1[0].position = a1_pos
		else:
			c1[0].position = c1_pos
	elif c1[0].get_node("MoveablePanel").get_global_rect().intersects($Row2.get_global_rect()):
		if b4[0] == $Empty:
			b4[0] = c1[0]
			b4[1] = c1[1]
			c1[0] = $Empty
			c1[1] = "E"
			b4[0].position = b4_pos
		elif b3[0] == $Empty:
			b3[0] = c1[0]
			b3[1] = c1[1]
			c1[0] = $Empty
			c1[1] = "E"
			b3[0].position = b3_pos
		elif b2[0] == $Empty:
			b2[0] = c1[0]
			b2[1] = c1[1]
			c1[0] = $Empty
			c1[1] = "E"
			b2[0].position = b2_pos
		elif b1[0] == $Empty:
			b1[0] = c1[0]
			b1[1] = c1[1]
			c1[0] = $Empty
			c1[1] = "E"
			b1[0].position = b1_pos
		else:
			c1[0].position = c1_pos
	elif c1[0].get_node("MoveablePanel").get_global_rect().intersects($Row4.get_global_rect()):
		print("row4")
		if d4[0] == $Empty:
			d4[0] = c1[0]
			d4[1] = c1[1]
			c1[0] = $Empty
			c1[1] = "E"
			d4[0].position = d4_pos
		elif d3[0] == $Empty:
			d3[0] = c1[0]
			d3[1] = c1[1]
			c1[0] = $Empty
			c1[1] = "E"
			d3[0].position = d3_pos
		elif d2[0] == $Empty:
			d2[0] = c1[0]
			d2[1] = c1[1]
			c1[0] = $Empty
			c1[1] = "E"
			d2[0].position = d2_pos
		elif d1[0] == $Empty:
			d1[0] = c1[0]
			d1[1] = c1[1]
			c1[0] = $Empty
			c1[1] = "E"
			d1[0].position = d1_pos
		else:
			c1[0].position = c1_pos
	else:
			c1[0].position = c1_pos

func _on_c_2_button_up() -> void:
	draggingc2 = false
	if c2[1] == "E":
		pass
	elif c2[0].get_node("MoveablePanel").get_global_rect().intersects($Row1.get_global_rect()):
		if a4[0] == $Empty:
			a4[0] = c2[0]
			a4[1] = c2[1]
			c2[0] = $Empty
			c2[1] = "E"
			a4[0].position = a4_pos
		elif a3[0] == $Empty:
			a3[0] = c2[0]
			a3[1] = c2[1]
			c2[0] = $Empty
			c2[1] = "E"
			a3[0].position = a3_pos
		elif a2[0] == $Empty:
			a2[0] = c2[0]
			a2[1] = c2[1]
			c2[0] = $Empty
			c2[1] = "E"
			a2[0].position = a2_pos
		elif a1[0] == $Empty:
			a1[0] = c2[0]
			a1[1] = c2[1]
			c2[0] = $Empty
			c2[1] = "E"
			a1[0].position = a1_pos
		else:
			c2[0].position = c2_pos
	elif c2[0].get_node("MoveablePanel").get_global_rect().intersects($Row2.get_global_rect()):
		if b4[0] == $Empty:
			b4[0] = c2[0]
			b4[1] = c2[1]
			c2[0] = $Empty
			c2[1] = "E"
			b4[0].position = b4_pos
		elif b3[0] == $Empty:
			b3[0] = c2[0]
			b3[1] = c2[1]
			c2[0] = $Empty
			c2[1] = "E"
			b3[0].position = b3_pos
		elif b2[0] == $Empty :
			b2[0] = c2[0]
			b2[1] = c2[1]
			c2[0] = $Empty
			c2[1] = "E"
			b2[0].position = b2_pos
		elif b1[0] == $Empty:
			b1[0] = c2[0]
			b1[1] = c2[1]
			c2[0] = $Empty
			c2[1] = "E"
			b1[0].position = b1_pos
		else:
			c2[0].position = c2_pos
	elif c2[0].get_node("MoveablePanel").get_global_rect().intersects($Row4.get_global_rect()):
		if d4[0] == $Empty:
			d4[0] = c2[0]
			d4[1] = c2[1]
			c2[0] = $Empty
			c2[1] = "E"
			d4[0].position = d4_pos
		elif d3[0] == $Empty:
			d3[0] = c2[0]
			d3[1] = c2[1]
			c2[0] = $Empty
			c2[1] = "E"
			d3[0].position = d3_pos
		elif d2[0] == $Empty:
			d2[0] = c2[0]
			d2[1] = c2[1]
			c2[0] = $Empty
			c2[1] = "E"
			d2[0].position = d2_pos
		elif d1[0] == $Empty:
			d1[0] = c2[0]
			d1[1] = c2[1]
			c2[0] = $Empty
			c2[1] = "E"
			d1[0].position = d1_pos
		else:
			c2[0].position = c2_pos
	else:
		c2[0].position = c2_pos

func _on_c_3_button_up() -> void:
	draggingc3 = false
	if c3[1] == "E":
		pass
	elif c3[0].get_node("MoveablePanel").get_global_rect().intersects($Row1.get_global_rect()):
		if a4[0] == $Empty:
			a4[0] = c3[0]
			a4[1] = c3[1]
			c3[0] = $Empty
			c3[1] = "E"
			a4[0].position = a4_pos
		elif a3[0] == $Empty:
			a3[0] = c3[0]
			a3[1] = c3[1]
			c3[0] = $Empty
			c3[1] = "E"
			a3[0].position = a3_pos
		elif a2[0] == $Empty:
			a2[0] = c3[0]
			a2[1] = c3[1]
			c3[0] = $Empty
			c3[1] = "E"
			a2[0].position = a2_pos
		elif a1[0] == $Empty:
			a1[0] = c3[0]
			a1[1] = c3[1]
			c3[0] = $Empty
			c3[1] = "E"
			a1[0].position = a1_pos
		else:
			c3[0].position = c3_pos
	elif c3[0].get_node("MoveablePanel").get_global_rect().intersects($Row2.get_global_rect()):
		if b4[0] == $Empty:
			b4[0] = c3[0]
			b4[1] = c3[1]
			c3[0] = $Empty
			c3[1] = "E"
			b4[0].position = b4_pos
		elif b3[0] == $Empty:
			b3[0] = c3[0]
			b3[1] = c3[1]
			c3[0] = $Empty
			c3[1] = "E"
			b3[0].position = b3_pos
		elif b2[0] == $Empty:
			b2[0] = c3[0]
			b2[1] = c3[1]
			c3[0] = $Empty
			c3[1] = "E"
			b2[0].position = b2_pos
		elif b1[0] == $Empty:
			b1[0] = c3[0]
			b1[1] = c3[1]
			c3[0] = $Empty
			c3[1] = "E"
			b1[0].position = b1_pos
		else:
			c3[0].position = c3_pos
	elif c3[0].get_node("MoveablePanel").get_global_rect().intersects($Row4.get_global_rect()):
		if d4[0] == $Empty:
			d4[0] = c3[0]
			d4[1] = c3[1]
			c3[0] = $Empty
			c3[1] = "E"
			d4[0].position = d4_pos
		elif d3[0] == $Empty:
			d3[0] = c3[0]
			d3[1] = c3[1]
			c3[0] = $Empty
			c3[1] = "E"
			d3[0].position = d3_pos
		elif d2[0] == $Empty:
			d2[0] = c3[0]
			d2[1] = c3[1]
			c3[0] = $Empty
			c3[1] = "E"
			d2[0].position = d2_pos
		elif d1[0] == $Empty:
			d1[0] = c3[0]
			d1[1] = c3[1]
			c3[0] = $Empty
			c3[1] = "E"
			d1[0].position = d1_pos
		else:
			c3[0].position = c3_pos
	else:
		c3[0].position = c3_pos

func _on_c_4_button_up() -> void:
	draggingc4 = false
	if c4[1] == "E":
		pass
	elif c4[0].get_node("MoveablePanel").get_global_rect().intersects($Row1.get_global_rect()):
		if a4[0] == $Empty:
			a4[0] = c4[0]
			a4[1] = c4[1]
			c4[0] = $Empty
			c4[1] = "E"
			a4[0].position = a4_pos
		elif a3[0] == $Empty:
			a3[0] = c4[0]
			a3[1] = c4[1]
			c4[0] = $Empty
			c4[1] = "E"
			a3[0].position = a3_pos
		elif a2[0] == $Empty:
			a2[0] = c4[0]
			a2[1] = c4[1]
			c4[0] = $Empty
			c4[1] = "E"
			a2[0].position = a2_pos
		elif a1[0] == $Empty:
			a1[0] = c4[0]
			a1[1] = c4[1]
			c4[0] = $Empty
			c4[1] = "E"
			a1[0].position = a1_pos
		else:
			c4[0].position = c4_pos
	elif c4[0].get_node("MoveablePanel").get_global_rect().intersects($Row2.get_global_rect()):
		if b4[0] == $Empty:
			b4[0] = c4[0]
			b4[1] = c4[1]
			c4[0] = $Empty
			c4[1] = "E"
			b4[0].position = b4_pos
		elif b3[0] == $Empty:
			b3[0] = c4[0]
			b3[1] = c4[1]
			c4[0] = $Empty
			c4[1] = "E"
			b3[0].position = b3_pos
		elif b2[0] == $Empty:
			b2[0] = c4[0]
			b2[1] = c4[1]
			c4[0] = $Empty
			c4[1] = "E"
			b2[0].position = b2_pos
		elif b1[0] == $Empty:
			b1[0] = c4[0]
			b1[1] = c4[1]
			c4[0] = $Empty
			c4[1] = "E"
			b1[0].position = b1_pos
		else:
			c4[0].position = c4_pos
	elif c4[0].get_node("MoveablePanel").get_global_rect().intersects($Row4.get_global_rect()):
		if d4[0] == $Empty:
			d4[0] = c4[0]
			d4[1] = c4[1]
			c4[0] = $Empty
			c4[1] = "E"
			d4[0].position = d4_pos
		elif d3[0] == $Empty:
			d3[0] = c4[0]
			d3[1] = c4[1]
			c4[0] = $Empty
			c4[1] = "E"
			d3[0].position = d3_pos
		elif d2[0] == $Empty:
			d2[0] = c4[0]
			d2[1] = c4[1]
			c4[0] = $Empty
			c4[1] = "E"
			d2[0].position = d2_pos
		elif d1[0] == $Empty:
			d1[0] = c4[0]
			d1[1] = c4[1]
			c4[0] = $Empty
			c4[1] = "E"
			d1[0].position = d1_pos
		else:
			c4[0].position = c4_pos
	else:
		c4[0].position = c4_pos

func _on_d_1_button_up() -> void:
	draggingd1 = false
	if d1[1] == "E":
		pass
	elif d1[0].get_node("MoveablePanel").get_global_rect().intersects($Row1.get_global_rect()):
		if a4[0] == $Empty:
			a4[0] = d1[0]
			a4[1] = d1[1]
			d1[0] = $Empty
			d1[1] = "E"
			a4[0].position = a4_pos
		elif a3[0] == $Empty:
			a3[0] = d1[0]
			a3[1] = d1[1]
			d1[0] = $Empty
			d1[1] = "E"
			a3[0].position = a3_pos
		elif a2[0] == $Empty:
			a2[0] = d1[0]
			a2[1] = d1[1]
			d1[0] = $Empty
			d1[1] = "E"
			a2[0].position = a2_pos
		elif a1[0] == $Empty:
			a1[0] = d1[0]
			a1[1] = d1[1]
			d1[0] = $Empty
			d1[1] = "E"
			a1[0].position = a1_pos
		else:
			d1[0].position = d1_pos
	elif d1[0].get_node("MoveablePanel").get_global_rect().intersects($Row2.get_global_rect()):
		if b4[0] == $Empty:
			b4[0] = d1[0]
			b4[1] = d1[1]
			d1[0] = $Empty
			d1[1] = "E"
			b4[0].position = b4_pos
		elif b3[0] == $Empty:
			b3[0] = d1[0]
			b3[1] = d1[1]
			d1[0] = $Empty
			d1[1] = "E"
			b3[0].position = b3_pos
		elif b2[0] == $Empty:
			b2[0] = d1[0]
			b2[1] = d1[1]
			d1[0] = $Empty
			d1[1] = "E"
			b2[0].position = b2_pos
		elif b1[0] == $Empty:
			b1[0] = d1[0]
			b1[1] = d1[1]
			d1[0] = $Empty
			d1[1] = "E"
			b1[0].position = b1_pos
		else:
			d1[0].position = d1_pos
	elif d1[0].get_node("MoveablePanel").get_global_rect().intersects($Row3.get_global_rect()):
		if c4[0] == $Empty:
			c4[0] = d1[0]
			c4[1] = d1[1]
			d1[0] = $Empty
			d1[1] = "E"
			c4[0].position = c4_pos
		elif c3[0] == $Empty:
			c3[0] = d1[0]
			c3[1] = d1[1]
			d1[0] = $Empty
			d1[1] = "E"
			c3[0].position = c3_pos
		elif c2[0] == $Empty:
			c2[0] = d1[0]
			c2[1] = d1[1]
			d1[0] = $Empty
			d1[1] = "E"
			c2[0].position = c2_pos
		elif c1[0] == $Empty:
			c1[0] = d1[0]
			c1[1] = d1[1]
			d1[0] = $Empty
			d1[1] = "E"
			c1[0].position = c1_pos
		else:
			d1[0].position = d1_pos
	else:
		d1[0].position = d1_pos
func _on_d_2_button_up() -> void:
	draggingd2 = false
	if d2[1] == "E":
		pass
	elif d2[0].get_node("MoveablePanel").get_global_rect().intersects($Row1.get_global_rect()):
		if a4[0] == $Empty:
			a4[0] = d2[0]
			a4[1] = d2[1]
			d2[0] = $Empty
			d2[1] = "E"
			a4[0].position = a4_pos
		elif a3[0] == $Empty:
			a3[0] = d2[0]
			a3[1] = d2[1]
			d2[0] = $Empty
			d2[1] = "E"
			a3[0].position = a3_pos
		elif a2[0] == $Empty:
			a2[0] = d2[0]
			a2[1] = d2[1]
			d2[0] = $Empty
			d2[1] = "E"
			a2[0].position = a2_pos
		elif a1[0] == $Empty:
			a1[0] = d2[0]
			a1[1] = d2[1]
			d2[0] = $Empty
			d2[1] = "E"
			a1[0].position = a1_pos
		else:
			d2[0].position = d2_pos
	elif d2[0].get_node("MoveablePanel").get_global_rect().intersects($Row2.get_global_rect()):
		if b4[0] == $Empty:
			b4[0] = d2[0]
			b4[1] = d2[1]
			d2[0] = $Empty
			d2[1] = "E"
			b4[0].position = b4_pos
		elif b3[0] == $Empty:
			b3[0] = d2[0]
			b3[1] = d2[1]
			d2[0] = $Empty
			d2[1] = "E"
			b3[0].position = b3_pos
		elif b2[0] == $Empty:
			b2[0] = d2[0]
			b2[1] = d2[1]
			d2[0] = $Empty
			d2[1] = "E"
			b2[0].position = b2_pos
		elif b1[0] == $Empty:
			b1[0] = d2[0]
			b1[1] = d2[1]
			d2[0] = $Empty
			d2[1] = "E"
			b1[0].position = b1_pos
		else:
			d2[0].position = d2_pos
	elif d2[0].get_node("MoveablePanel").get_global_rect().intersects($Row3.get_global_rect()):
		if c4[0] == $Empty:
			c4[0] = d2[0]
			c4[1] = d2[1]
			d2[0] = $Empty
			d2[1] = "E"
			c4[0].position = c4_pos
		elif c3[0] == $Empty:
			c3[0] = d2[0]
			c3[1] = d2[1]
			d2[0] = $Empty
			d2[1] = "E"
			c3[0].position = c3_pos
		elif c2[0] == $Empty:
			c2[0] = d2[0]
			c2[1] = d2[1]
			d2[0] = $Empty
			d2[1] = "E"
			c2[0].position = c2_pos
		elif c1[0] == $Empty:
			c1[0] = d2[0]
			c1[1] = d2[1]
			d2[0] = $Empty
			d2[1] = "E"
			c1[0].position = c1_pos
		else:
			d2[0].position = d2_pos
	else:
		d2[0].position = d2_pos
func _on_d_3_button_up() -> void:
	draggingd3 = false
	if d3[1] == "E":
		pass
	elif d3[0].get_node("MoveablePanel").get_global_rect().intersects($Row1.get_global_rect()):
		if a4[0] == $Empty:
			a4[0] = d3[0]
			a4[1] = d3[1]
			d3[0] = $Empty
			d3[1] = "E"
			a4[0].position = a4_pos
		elif a3[0] == $Empty:
			a3[0] = d3[0]
			a3[1] = d3[1]
			d3[0] = $Empty
			d3[1] = "E"
			a3[0].position = a3_pos
		elif a2[0] == $Empty:
			a2[0] = d3[0]
			a2[1] = d3[1]
			d3[0] = $Empty
			d3[1] = "E"
			a2[0].position = a2_pos
		elif a1[0] == $Empty:
			a1[0] = d3[0]
			a1[1] = d3[1]
			d3[0] = $Empty
			d3[1] = "E"
			a1[0].position = a1_pos
		else:
			d3[0].position = d3_pos
	elif d3[0].get_node("MoveablePanel").get_global_rect().intersects($Row2.get_global_rect()):
		if b4[0] == $Empty:
			b4[0] = d3[0]
			b4[1] = d3[1]
			d3[0] = $Empty
			d3[1] = "E"
			b4[0].position = b4_pos
		elif b3[0] == $Empty:
			b3[0] = d3[0]
			b3[1] = d3[1]
			b1[0] = $Empty
			d3[1] = "E"
			b3[0].position = b3_pos
		elif b2[0] == $Empty:
			b2[0] = d3[0]
			b2[1] = d3[1]
			d3[0] = $Empty
			d3[1] = "E"
			b2[0].position = b2_pos
		elif b1[0] == $Empty:
			b1[0] = d3[0]
			b1[1] = d3[1]
			d3[0] = $Empty
			d3[1] = "E"
			b1[0].position = b1_pos
		else:
			d3[0].position = d3_pos
	elif d3[0].get_node("MoveablePanel").get_global_rect().intersects($Row3.get_global_rect()):
		if c4[0] == $Empty:
			c4[0] = d3[0]
			c4[1] = d3[1]
			d3[0] = $Empty
			d3[1] = "E"
			c4[0].position = c4_pos
		elif c3[0] == $Empty:
			c3[0] = d3[0]
			c3[1] = d3[1]
			d3[0] = $Empty
			d3[1] = "E"
			c3[0].position = c3_pos
		elif c2[0] == $Empty:
			c2[0] = d3[0]
			c2[1] = d3[1]
			d3[0] = $Empty
			d3[1] = "E"
			c2[0].position = c2_pos
		elif c1[0] == $Empty:
			c1[0] = d3[0]
			c1[1] = d3[1]
			d3[0] = $Empty
			d3[1] = "E"
			c1[0].position = c1_pos
		else:
			d3[0].position = d3_pos
	else:
		d3[0].position = d3_pos

func _on_d_4_button_up() -> void:
	draggingd4 = false
	if d4[1] == "E":
		pass
	elif d4[0].get_node("MoveablePanel").get_global_rect().intersects($Row1.get_global_rect()):
		if a4[0] == $Empty:
			a4[0] = d4[0]
			a4[1] = d4[1]
			d4[0] = $Empty
			d4[1] = "E"
			a4[0].position = a4_pos
		elif a3[0] == $Empty:
			a3[0] = d4[0]
			a3[1] = d4[1]
			d4[0] = $Empty
			d4[1] = "E"
			a3[0].position = a3_pos
		elif a2[0] == $Empty:
			a2[0] = d4[0]
			a2[1] = d4[1]
			d4[0] = $Empty
			d4[1] = "E"
			a2[0].position = a2_pos
		elif a1[0] == $Empty:
			a1[0] = d4[0]
			a1[1] = d4[1]
			d4[0] = $Empty
			d4[1] = "E"
			a1[0].position = a1_pos
		else:
			d4[0].position = d4_pos
	elif d4[0].get_node("MoveablePanel").get_global_rect().intersects($Row2.get_global_rect()):
		if b4[0] == $Empty:
			b4[0] = d4[0]
			b4[1] = d4[1]
			d4[0] = $Empty
			d4[1] = "E"
			b4[0].position = b4_pos
		elif b3[0] == $Empty:
			b3[0] = d4[0]
			b3[1] = d4[1]
			d4[0] = $Empty
			d4[1] = "E"
			b3[0].position = b3_pos
		elif b2[0] == $Empty:
			b2[0] = d4[0]
			b2[1] = d4[1]
			d4[0] = $Empty
			d4[1] = "E"
			b2[0].position = b2_pos
		elif b1[0] == $Empty:
			b1[0] = d4[0]
			b1[1] = d4[1]
			d4[0] = $Empty
			d4[1] = "E"
			b1[0].position = b1_pos
		else:
			d4[0].position = d4_pos
	elif d4[0].get_node("MoveablePanel").get_global_rect().intersects($Row3.get_global_rect()):
		if c4[0] == $Empty:
			c4[0] = d4[0]
			c4[1] = d4[1]
			d4[0] = $Empty
			d4[1] = "E"
			c4[0].position = c4_pos
		elif c3[0] == $Empty:
			c3[0] = d4[0]
			c3[1] = d4[1]
			d4[0] = $Empty
			d4[1] = "E"
			c3[0].position = c3_pos
		elif c2[0] == $Empty:
			c2[0] = d4[0]
			c2[1] = d4[1]
			d4[0] = $Empty
			d4[1] = "E"
			c2[0].position = c2_pos
		elif c1[0] == $Empty:
			c1[0] = d4[0]
			c1[1] = d4[1]
			d4[0] = $Empty
			d4[1] = "E"
			c1[0].position = c1_pos
		else:
			d4[0].position = d4_pos
	else:
		d4[0].position = d4_pos
#endregion
