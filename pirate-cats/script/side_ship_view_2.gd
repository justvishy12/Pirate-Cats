extends Node2D
var moveleft = false
var moveright = false
var locked = false
var scrubbing = false
var scrubbing2 = false
var bubbles = false
var can_play = false
var dialogue=[
#If player hasn’t done scrubber puzzle:
	{
		#0
		"speaker": "cat",
		"name": "Mopps (Scrubber)",
		"text": "Ugh, there’s too much to clean. ",
		"portrait": preload("res://assets/headshots/SCRUBBER FACE.png")
	},
{
		#1
		"speaker": "you",
		"name": "",
		"text": "Need a hand? "
	},
	{
		#2
		"speaker": "cat",
		"name": "Mopps (Scrubber)",
		"text": "I would really appreciate it! ",
		"portrait": preload("res://assets/headshots/SCRUBBER FACE.png")
	},

#If player has done scrubber puzzle:
	{
		#3
		"speaker": "cat",
		"name": "Mopps (Scrubber)",
		"text": "The deck shines of  sapp-furr! ",
		"portrait": preload("res://assets/headshots/SCRUBBER FACE.png")
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
			if SaveManager.scrub == false and dialogue_index == 2:
				print(dialogue_index)
				get_tree().change_scene_to_file("res://scene/Scrubbing MG.tscn")
			if SaveManager.scrub == true and dialogue_index == 3:
				locked = false
				can_play = false
				$Camera2D/Textbox.visible = false
				scrubbing2 = false
			if dialogue_index == 5:
				$Camera2D/mapbutton.visible=true
			if dialogue_index == 6:
				$Camera2D/mapbutton.disabled = false
			if dialogue_index != 2 and dialogue_index != 3:
				dialogue_index += 1
				show_next_dialogue()
			
func _on_player_button_pressed() -> void:
	dialogue_index += 1
	show_next_dialogue()

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Global.rightcam == true:
		$Camera2D.position.x = 288
	elif Global.leftcam == true:
		$Camera2D.position.x = 812

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if SaveManager.cook and SaveManager.captain == false and SaveManager.scrub and SaveManager.feed and SaveManager.sort and SaveManager.fish and !SaveManager.captain:
		SaveManager.captain = true
		can_play = true
		locked = true
		$ScrubberMG.monitorable = false
		$ScrubberMG/CollisionShape2D.disabled = true
		dialogue_index = 4
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






func _on_move_left_mouse_entered() -> void:
	moveleft = true


func _on_move_left_mouse_exited() -> void:
	moveleft = false


func _on_moveright_mouse_entered() -> void:
	moveright = true


func _on_moveright_mouse_exited() -> void:
	moveright = false


func _on_front_ship_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		Global.leftcam = false
		Global.rightcam = true
		get_tree().change_scene_to_file("res://scene/FrontShip.tscn")


func _on_back_ship_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		Global.leftcam = true
		Global.rightcam = false
		get_tree().change_scene_to_file("res://scene/Backship.tscn")


func _on_scrubber_mg_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		can_play = true
		Global.rightcam = false
		Global.leftcam = false
		if SaveManager.scrub == false:
			locked = true
			$Camera2D.global_position.x = 812
			dialogue_index = 0
			scrubbing = true
			show_next_dialogue()
		elif SaveManager.scrub == true:
			dialogue_index = 3
			locked = true
			$Camera2D.global_position.x = 812
			scrubbing2 = true
			show_next_dialogue()

func _on_mapbutton_pressed() -> void:
	$Camera2D/mapbutton.visible=false
	$Camera2D/CaptainCat.visible=false
	$ScrubberMG.monitorable = true
	$ScrubberMG/CollisionShape2D.disabled = false
	locked=false


func _on_bubble_bucket_mouse_entered() -> void:
	$BubbleBuket.play("default")


func _on_bubble_bucket_mouse_exited() -> void:
	$BubbleBuket.stop()
