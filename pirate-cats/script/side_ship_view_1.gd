extends Node2D
var moveleft = false
var moveright = false
var flag = 0

var sorting = false
var sorting2 = false
var locked = false
var can_play = false
var dialogue=[
#If player hasn’t done powder monkey puzzle:
	{
		#0
		"speaker": "cat",
		"name": "Smokey (Powder Monkey)",
		"text": "Boom Boom Boom ",
		"portrait": preload("res://assets/headshots/POWDER MONKEY FACE.png")
	},
{
		#1
		"speaker": "you",
		"name": "",
		"text": "Are the crabs attacking again?"
	},
	{
		#2
		"speaker": "cat",
		"name": "Smokey (Powder Monkey)",
		"text": "No, just practicing my aim. ",
		"portrait": preload("res://assets/headshots/POWDER MONKEY FACE.png")
	},
	{
		#3
		"speaker": "cat",
		"name": "Smokey (Powder Monkey)",
		"text": "Boom Bo- … ",
		"portrait": preload("res://assets/headshots/POWDER MONKEY FACE.png")
	},
	{
		#4
		"speaker": "cat",
		"name": "Smokey (Powder Monkey)",
		"text": "Why was a coconut fired from my water balloon cannon?! ",
		"portrait": preload("res://assets/headshots/POWDER MONKEY FACE.png")
	},
{
		#5
		"speaker": "you",
		"name": "",
		"text": "Let me help!"
	},

#If player has done powder monkey puzzle:
	{
		#3
		"speaker": "cat",
		"name": "Smokey (Powder Monkey)",
		"text": "Boom Boom Boom ",
		"portrait": preload("res://assets/headshots/POWDER MONKEY FACE.png")
	},
	#captian map
	{
		#4
		"speaker": "cat",
		"name": "Cat Sparrow (Captain)",
		"text": "This is a little embarrasing... ",
		"portrait": preload("res://assets/headshots/CAPTIAN FACE.png")
	},
		{
		#5
		"speaker": "cat",
		"name": "Cat Sparrow (Captain)",
		"text": "Turns out the last map piece was in my pocket. ",
		"portrait": preload("res://assets/headshots/CAPTIAN FACE.png")
	},
	{
		#6
		"speaker": "cat",
		"name": "Cat Sparrow (Captain)",
		"text": "Let's go assemble it at my desk. ",
		"portrait": preload("res://assets/headshots/CAPTIAN FACE.png")
	},
	]
var dialogue_index = 0
var typing = false

func show_next_dialogue() -> void:
	if dialogue_index >= dialogue.size():
		$Camera2D/Textbox.visible = false
		$"Camera2D/player button".visible = false
		return
	
	var line = dialogue[dialogue_index]
	if line["speaker"] == "you":
		$Camera2D/Textbox.visible = false
		$"Camera2D/player button".visible = true
		$"Camera2D/player button".text = line["text"]
		
	elif line["speaker"] == "cat":
		$"Camera2D/player button".visible = false
		show_cat_text(line)

func show_cat_text(line) -> void:
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
		if !is_inside_tree():
			return
		$Camera2D/Textbox/textlabel.visible_characters = i
		await get_tree().create_timer(SaveManager.speed, false).timeout
	$Typing.stop()
	typing = false

func _input(event):
	if event.is_action_pressed("ui_accept") and !typing and can_play == true:
		if dialogue_index < dialogue.size() and dialogue[dialogue_index]["speaker"] == "cat":
			if sorting2 == true and dialogue_index == 3:
				locked = false
				$Camera2D/Textbox.visible = false
				can_play = false
				sorting2 = false
			if dialogue_index == 8:
				$Camera2D/mapbutton.visible=true
			if dialogue_index == 9:
				$Camera2D/mapbutton.disabled = false
			if dialogue_index != 5 and dialogue_index != 6:
				dialogue_index += 1
				show_next_dialogue()
			if dialogue_index == 6:
				locked = false
				$Camera2D/Textbox.visible = false
			
func _on_player_button_pressed() -> void:
	if sorting == true and dialogue_index == 5:
		get_tree().change_scene_to_file("res://scene/SortingMG.tscn")
	dialogue_index += 1
	show_next_dialogue()


func _ready() -> void:
	if Global.rightcam == true:
		$Camera2D.position.x = 288
	elif Global.leftcam == true:
		$Camera2D.position.x = 812


func _process(delta: float) -> void:
	if SaveManager.cook and SaveManager.captain == false and SaveManager.scrub and SaveManager.feed and SaveManager.sort and SaveManager.fish:
		SaveManager.captain = true
		can_play = true
		locked = true
		dialogue_index = 7
		$PowderMG.monitorable = false
		$Camera2D/CaptainCat.visible=true
		show_next_dialogue()
		return
	
	
	
	if moveleft == true and locked == false:
		$Camera2D.global_position += Vector2(-150, 0) * delta
	$Camera2D.global_position.x = clamp(
		$Camera2D.global_position.x,
		288,
		813
	)
	if moveright == true and locked == false:
		$Camera2D.global_position += Vector2(150, 0) * delta
	$Camera2D.global_position.x = clamp(
		$Camera2D.global_position.x,
		288,
		813
	)

func _on_crab_out_mouse_entered() -> void:
	$AnimatedSprite2D.play("default")

func _on_crab_out_mouse_exited() -> void:
	$AnimatedSprite2D.stop()

func _on_dyna_play_mouse_entered() -> void:
	$Dynamite.play("default")

func _on_dyna_play_mouse_exited() -> void:
	$Dynamite.stop()

func _on_bouy_play_mouse_entered() -> void:
	$Bouy.play("default")

func _on_bouy_play_mouse_exited() -> void:
	$Bouy.stop()


func _on_cam_left_mouse_entered() -> void:
	moveleft = true


func _on_cam_left_mouse_exited() -> void:
	moveleft = false


func _on_cam_right_mouse_entered() -> void:
	moveright = true

func _on_cam_right_mouse_exited() -> void:
	moveright = false

func _on_flag_raise_mouse_entered() -> void:
	var anim = $AnimationPlayer.get_animation("FlagRaise")

	if flag == 0:
		flag = 1
		$AnimationPlayer.play("FlagRaise", -1, 1.0)
	else:
		flag = 0
		var current_time = $AnimationPlayer.current_animation_position
		$AnimationPlayer.play("FlagRaise", -1, -1.0)
		$AnimationPlayer.seek(current_time, true)


func _on_back_ship_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		Global.rightcam = true
		Global.leftcam = false
		get_tree().change_scene_to_file("res://scene/Backship.tscn")


func _on_front_ship_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		Global.leftcam = true
		Global.rightcam = false
		get_tree().change_scene_to_file("res://scene/FrontShip.tscn")


func _on_powder_mg_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		can_play = true
		Global.rightcam = false
		Global.leftcam = false
		if SaveManager.sort == false:
			locked = true
			$Camera2D.global_position.x = 417
			dialogue_index = 0
			sorting = true
			show_next_dialogue()
		elif SaveManager.sort == true:
			dialogue_index = 6
			locked = true
			$Camera2D.global_position.x = 417
			sorting2 = true
			show_next_dialogue()

func _on_mapbutton_pressed() -> void:
	$Camera2D/mapbutton.visible=false
	$Camera2D/CaptainCat.visible=false
	$PowderMG.monitorable = true
	locked=false
	
