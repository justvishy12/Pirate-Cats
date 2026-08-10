extends Node2D
var layer1
var layer2
var topping
var lone
var ltwo
var star
var shell
var flag
var plate = 0
var plates = 0
var plate_anim = false
var base
var top
var game_start = false
var dialogue_busy = false
var done = false
#CheckOrder
var OBase1 = false
var OBase2 = false
var OTop1 = false
var OTop2 = false
var OShell = false
var OFlag = false
var OStar = false
#OnPlate
var PBase1 = false
var PBase2 = false
var PTop1 = false
var PTop2 = false
var PShell = false
var PFlag = false
var PStar = false
# Correct Items
var CBase1 = false
var CBase2 = false
var CTop1 = false
var CTop2 = false
var CShell = false
var CFlag = false
var CStar = false
var skip_typing = false
var dialogue = [
	{
		#0
		"speaker": "you",
		"name": "",
		"text": "Are you going to cook? "
	},
	{
		#1
		"speaker": "cat",
		"name": "Biscuits (Cook)",
		"text": "No, but I will teach you how! ",
		"portrait": preload("res://assets/headshots/CHEF FACE.png")
	},
	{ 
		#2
		"speaker": "cat",
		"name": "Biscuits (Cook)",
		"text": "First Drag a plate into the bordered line! ",
		"portrait": preload("res://assets/headshots/CHEF FACE.png")
	},
	{
		#3
		"speaker": "plate",
		"name": "Biscuits (Cook)",
		"text": "Then add the Castles based on the order! ",
		"portrait": preload("res://assets/headshots/CHEF FACE.png")
	},
	{
		#4
		"speaker": "base",
		"name": "Biscuits (Cook)",
		"text": "Then if needed, add the toppings! ",
		"portrait": preload("res://assets/headshots/CHEF FACE.png")
	},
	{
		#5
		"speaker": "you(start)",
		"name": "",
		"text": "Whoa I did it "
	},
	{
		#6
		"speaker": "toppings",
		"name": "Biscuits (Cook)",
		"text": "Yes you did, press the arrow to go back and make more (3)! ",
		"portrait": preload("res://assets/headshots/CHEF FACE.png")
	},
	{
		#7
		"speaker": "cat",
		"name": "Biscuits (Cook)",
		"text": "Leave it on the captain's desk! He'll be really happy. ",
		"portrait": preload("res://assets/headshots/CHEF FACE.png")
	},
	
]

var dialogue_index = 0
var typing = false



func show_next_dialogue() -> void:
	if dialogue_busy:
		return
	print(dialogue_index)
	dialogue_busy = true

	if dialogue_index >= dialogue.size():
		$Camera2D/Textbox.visible = false
		$"Camera2D/player button".visible = false
		dialogue_busy = false
		return
	
	var line = dialogue[dialogue_index]
	
	if line["speaker"] == "you":
		$Camera2D/Textbox.visible = false
		$"Camera2D/player button".visible = true
		$"Camera2D/player button".text = line["text"]
	
	
		
	elif line["speaker"] == "you(start)":
		$Camera2D/Textbox.visible = false
		$"Camera2D/player button".visible = true
		$"Camera2D/player button".text = line["text"]
		game_start = true
		
	elif line["speaker"] == "cat":
		$"Camera2D/player button".visible = false
		show_cat_text(line)
		
	elif line["speaker"] == "plate": #moves from getting plate to gettitng base
		if plates == 0:
			plates = 1
			$MiddlePlate.visible = true
			$"Camera2D/player button".visible = false
			await get_tree().create_timer(0.4).timeout
			$AnimationPlayer.play("PlateFinish")
			await get_tree().create_timer(0.65).timeout
			$AnimationPlayer2.play("PlateMenu")
			show_cat_text(line)

	elif line["speaker"] == "base": #moves from getting base to getting toppings
		$"Camera2D/player button".visible = false
		$AnimationPlayer.play("CastleFinish")
		await get_tree().create_timer(0.65).timeout
		$AnimationPlayer2.play("CastleMenu")
		show_cat_text(line)
		
	elif line["speaker"] == "toppings" and $Arrow2.visible == false: #goes to then end to check toppings
		$Platesss.visible = false
		$AnimationPlayer.play("ToppingsFinish")
		$AnimationPlayer2.play("MenuBack")
		plate_anim = false
		game_start = true
		order()
		plate_check()
		show_cat_text(line)
	dialogue_busy = false

func _on_player_button_pressed() -> void:
	$"Camera2D/player button".visible = false
	dialogue_index += 1
	show_next_dialogue()
	
func show_cat_text(line) -> void:
	skip_typing = false
	$Camera2D/Textbox.visible = true
	typing = true
	
	$Camera2D/Textbox/namelabel.text = line["name"]
	$Camera2D/Textbox/textlabel.text = line["text"]
	
	if line.has("portrait"):
		$Camera2D/Textbox/photobox.texture = line["portrait"]
	else:
		$Camera2D/Textbox/photobox.texture = null
	$Camera2D/Textbox/textlabel.visible_characters = 0
	$Typing.play()
	for i in $Camera2D/Textbox/textlabel.text.length():
		if skip_typing:
			$Camera2D/Textbox/textlabel.visible_characters = $Camera2D/Textbox/textlabel.text.length()
			break
		if !is_inside_tree():
			return
		$Camera2D/Textbox/textlabel.visible_characters = i
		await get_tree().create_timer(SaveManager.speed, false).timeout
	$Typing.stop()
	typing = false
	
func _input(event):
	if dialogue_busy:
		return
	if event.is_action_pressed("ui_accept") and !typing:
		if dialogue_index < dialogue.size() and dialogue[dialogue_index]["speaker"] == "cat":
			print(dialogue_index)
			if dialogue_index == 7:
				get_tree().change_scene_to_file("res://scene/Backship.tscn")
			if dialogue_index == 2 and $MiddlePlate.global_position == Vector2(75,510):
				return
			dialogue_index += 1
			show_next_dialogue()
		elif dialogue_index < dialogue.size() and dialogue[dialogue_index]["speaker"] == "plate":
			print(dialogue_index)
			if $MiddlePlate/Top2.visible == false and $MiddlePlate/Top1.visible == false and $"MiddlePlate/Top2-1".visible == false and $"MiddlePlate/Top1-1".visible == false and $MiddlePlate/Bottom1.visible == false and $MiddlePlate/Bottom2.visible == false:
				return
			dialogue_index += 1
			show_next_dialogue()
		elif dialogue_index < dialogue.size() and dialogue[dialogue_index]["speaker"] == "base":
			print(dialogue_index)
			dialogue_index += 1
			show_next_dialogue()
		elif dialogue_index < dialogue.size() and dialogue[dialogue_index]["speaker"] == "toppings":
			$Camera2D/Textbox.visible = false
	elif event.is_action_pressed("ui_accept") and typing:
		skip_typing = true
		$Camera2D/Textbox/textlabel.visible_characters = $Camera2D/Textbox/textlabel.text.length()
			
func plate_reset(): #resets the plate making everything dragable again and clickable again and puts everything back into position and visible
	$MiddlePlate.can_drag = true
	$MiddlePlate.dragging = false
	$MiddlePlate.in_zone = false
	$Bottom1.can_drag = true
	$Bottom1.in_zone = false
	$Bottom2.can_drag = true
	$Bottom2.in_zone = false
	$Top1.can_drag = true
	$Top1.in_zone = false
	$Top2.can_drag = true
	$Top2.in_zone = false
	$Star.can_drag = true
	$Star.in_zone = false
	$Flag.can_drag = true
	$Flag.in_zone = false
	$Clam.can_drag = true
	$Clam.in_zone = false
	$Bottom1.visible = true
	$Bottom2.visible = true
	$Top1.visible = true
	$Top2.visible = true
	$Star.visible = true
	$Flag.visible = true
	$Clam.visible = true
	$MiddlePlate.self_modulate = Color(1.0, 1.0, 1.0, 0.0)
	$MiddlePlate.global_position = Vector2(75,510)
	$MiddlePlate/Flag1.visible = false
	$MiddlePlate/Flag2.visible = false
	$MiddlePlate/Flag3.visible = false
	$MiddlePlate/Top2.visible = false
	$MiddlePlate/Top1.visible = false
	$"MiddlePlate/Top2-1".visible = false
	$"MiddlePlate/Top1-1".visible = false
	$MiddlePlate/Bottom1.visible = false
	$MiddlePlate/Bottom2.visible = false
	$MiddlePlate/SmallBase/Star.visible = false
	$MiddlePlate/SmallBase/Star2.visible = false
	$MiddlePlate/SmallBase/Clam.visible = false
	$MiddlePlate/SmallBase/Clam2.visible = false
	$MiddlePlate/BigBase/Star3.visible = false
	$MiddlePlate/BigBase/Star4.visible = false
	$MiddlePlate/BigBase/Clam3.visible = false
	$MiddlePlate/BigBase/Clam4.visible = false
	$MiddlePlate/NoBase/Star6.visible = false
	$MiddlePlate/NoBase/Clam5.visible = false
	order()

func _ready() -> void:
	$"Puzzle Music".play()
	show_next_dialogue()
	$Camera2D.position = Vector2(299,463)
	$MiddlePlate.self_modulate = Color(1.0, 1.0, 1.0, 0.0)
	$MiddlePlate.global_position = Vector2(75,510)
	order()
	
func _process(delta: float) -> void:
	if $Plates/Plate1.visible == false and $Plates/Plate2.visible == false and $Plates/Plate3.visible == false  and $Plates/Plate4.visible == false: #checks if all plates are made
		if done == false:
			done = true
			SaveManager.cook = true
			SaveManager.save_game(SaveManager.current_slot)
			dialogue_index = 7
			show_next_dialogue()
			$Plates/mapbutton.visible = true
			$AnimationPlayer.play("map")
			await $AnimationPlayer.animation_finished
			
	if $MiddlePlate/Panel.get_global_rect().intersects($PlatePanel.get_global_rect()) and plate_anim == false and $MiddlePlate.in_zone == true:
		#checks if u dragged the plate into the zone
		print("work 1")
		plate_anim = true
		if game_start == true:
			print("work 2")
			$Arrow.visible = true
			$Arrow2.visible = true
			$Arrow3.visible = true
			if plate != 4:
				await get_tree().create_timer(0.4).timeout
				$AnimationPlayer.play("PlateFinish")
				await get_tree().create_timer(0.65).timeout
				$AnimationPlayer2.play("PlateMenu")
	if plate == 1:
		$Plates/Plate1.visible = false
	if plate == 2:
		$Plates/Plate2.visible = false
	if plate == 3:
		$Plates/Plate3.visible = false
	if plate == 4:
		$Plates/Plate4.visible = false

func order():
	
	OTop1 = false
	OTop2 = false
	OShell = false
	OFlag = false
	OStar = false
	OBase1 = false
	OBase2 = false
		#OnPlate
	PBase1 = false
	PBase2 = false
	PTop1 = false
	PTop2 = false
	PShell = false
	PFlag = false
	PStar = false
	# Correct Items
	CBase1 = false
	CBase2 = false
	CTop1 = false
	CTop2 = false
	CShell = false
	CFlag = false
	CStar = false
	layer1 = randi_range(1,2)
	layer2 = randi_range(1,2)
	star = randi_range(1,2)
	shell = randi_range(1,2)
	flag = randi_range(1,2)
	$Order/Bottom1.visible = false
	$Order/Flag1.visible = false
	$Order/Flag3.visible = false
	$Order/Bottom2.visible = false
	$Order/Top1.visible = false
	$Order/Top2.visible = false
	$"Order/Top1-1".visible = false
	$"Order/Top2-1".visible = false
	$Order/SmallBase/Star.visible = false
	$Order/SmallBase/Star2.visible = false
	$Order/SmallBase/Clam.visible = false
	$Order/SmallBase/Clam2.visible = false
	$Order/BigBase/Star3.visible = false
	$Order/BigBase/Star4.visible = false
	$Order/BigBase/Clam3.visible = false
	$Order/BigBase/Clam4.visible = false
	$Order/NoBase/Star6.visible = false
	$Order/NoBase/Clam5.visible = false
	
	while layer1 == 1 and layer2 == 1:
		layer1 = randi_range(1,2)
		layer2 = randi_range(1,2)
	
	if layer1 == 2:
		lone = randi_range(1,2)
		if lone == 1:
			$Order/Bottom1.visible = true
			$Order/Bottom2.visible = false
			OBase1 = true
		else:
			$Order/Bottom1.visible = false
			$Order/Bottom2.visible = true
			OBase2 = true
			
	if layer2 == 2:
		ltwo = randi_range(1,2)
		if ltwo == 1:
			OTop1 = true
			if layer1 == 2:
				$Order/Top2.visible = true
			else:
				$"Order/Top2-1".visible = true
		else:
			OTop2 = true
			if layer1 == 2:
				$Order/Top1.visible = true
			else:
				$"Order/Top1-1".visible = true

	if star == 2:
		OStar = true
		if layer1 == 2:
			if $Order/Bottom1.visible == true:
				$Order/SmallBase/Star.visible = true
				$Order/SmallBase/Star2.visible = true
			else:
				$Order/BigBase/Star3.visible = true
				$Order/BigBase/Star4.visible = true
		else:
			$Order/NoBase/Star6.visible = true
	if shell == 2:
		OShell = true
		if layer1 == 2:
			if $Order/Bottom1.visible == true:
				$Order/SmallBase/Clam.visible = true
				$Order/SmallBase/Clam2.visible = true
			else:
				$Order/BigBase/Clam3.visible = true
				$Order/BigBase/Clam4.visible = true
		else:
			$Order/NoBase/Clam5.visible = true
	if flag == 2:
		OFlag = true
		if layer2 == 2:
			if layer1 == 2:
				$Order/Flag1.visible = true
			else:
				$Order/Flag3.visible = true
		else:
			$Order/Flag3.visible = true
func plate_check():
	if $MiddlePlate/Bottom1.visible == true:
		PBase1 = true
	if $MiddlePlate/Bottom2.visible == true:
		PBase2 = true
	if $MiddlePlate/Top1.visible == true or $"MiddlePlate/Top1-1".visible == true:
		PTop1 = true
	if $MiddlePlate/Top2.visible == true or $"MiddlePlate/Top2-1".visible == true:
		PTop2 = true
	if $MiddlePlate/SmallBase/Clam.visible == true or $MiddlePlate/BigBase/Clam3.visible == true or $MiddlePlate/NoBase/Clam5.visible == true:
		PShell = true
	if $MiddlePlate/SmallBase/Star.visible == true or $MiddlePlate/BigBase/Star3.visible == true or $MiddlePlate/NoBase/Star6.visible == true:
		PStar = true
	if $MiddlePlate/Flag1.visible == true or $MiddlePlate/Flag3.visible == true or $MiddlePlate/Flag3.visible == true:
		PFlag = true
	
	if OBase1 == PBase1:
		CBase1 = true
		$B1.modulate = Color(4.869, 4.869, 4.869)
		print(CBase1)
	if OBase2 == PBase2:
		CBase2 = true
		$B2.modulate = Color(4.869, 4.869, 4.869)
		print(CBase2)
	if OTop1 == PTop1 :
		CTop1 = true
		$T1.modulate = Color(4.869, 4.869, 4.869)
		print(CTop1)
	if OTop2 == PTop2:
		CTop2 = true
		$T2.modulate = Color(4.869, 4.869, 4.869)
		print(CTop2 )
	if OShell == PShell:
		CShell = true
		$C1.modulate = Color(4.869, 4.869, 4.869)
		print(CShell)
	if OStar == PStar:
		CStar = true
		$S1.modulate = Color(4.869, 4.869, 4.869)
		print(CStar)
	if OFlag == PFlag:
		CFlag  = true
		$F1.modulate = Color(4.869, 4.869, 4.869)
		print(CFlag )
		
func _on_buttonmove_pressed() -> void:
	if game_start:
		$AnimationPlayer.play("CastleFinish")
		await get_tree().create_timer(0.65).timeout
		$AnimationPlayer2.play("CastleMenu")
		
func _on_buttonmove_1_pressed() -> void:
	if game_start:
		$AnimationPlayer.play("ToppingsFinish")
		$AnimationPlayer2.play("MenuBack")
		plate_check()


func _on_mapbutton_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/Backship.tscn")


func _on_buttonmove_15_pressed() -> void:
	plate_anim = false
	order()
	$AnimationPlayer2.play("Reset")
	await get_tree().create_timer(0.3).timeout
	plate_reset()
