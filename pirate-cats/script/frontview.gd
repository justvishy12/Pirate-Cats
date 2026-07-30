extends Node2D
var movedown = false
var moveup = false
var flag = 0
var feeding = false
var feeding2 = false
var locked = false
var can_play = false
var dialogue=[
#If player hasn’t done parrot puzzle:
	{
		#0
		"speaker": "cat",
		"name": "Polly (Parrot)",
		"text": "Bawk, Polly want a cracker ",
		"portrait": preload("res://assets/bird.png")
	},
{
		#1
		"speaker": "you",
		"name": "",
		"text": "Oh no, did no one feed you? "
	},
	{
		#2
		"speaker": "cat",
		"name": "Polly (Parrot)",
		"text": "Bawk, got any snacks? ",
		"portrait": preload("res://assets/bird.png")
	},
	#captian map
	{
		#8
		"speaker": "cat",
		"name": "Cat Sparrow (Captain)",
		"text": "This is a little embarrasing... ",
		"portrait": preload("res://assets/headshots/CAPTIAN FACE.png")
	},
		{
		#9
		"speaker": "cat",
		"name": "Cat Sparrow (Captain)",
		"text": "Turns out the last map piece was in my pocket. ",
		"portrait": preload("res://assets/headshots/CAPTIAN FACE.png")
	},
	{
		#10
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
	
	for i in $Camera2D/Textbox/textlabel.text.length():
		if !is_inside_tree():
			return
		$Camera2D/Textbox/textlabel.visible_characters = i
		await get_tree().create_timer(SaveManager.speed, false).timeout
	
	typing = false

func _input(event):
	if event.is_action_pressed("ui_accept") and !typing and can_play == true:
		if dialogue_index < dialogue.size() and dialogue[dialogue_index]["speaker"] == "cat":
			if feeding2 == true and dialogue_index == 2:
				$Camera2D/Textbox.visible = false
				can_play = false
				feeding2 = false
			if dialogue_index == 4:
				$Camera2D/mapbutton.visible=true
			if dialogue_index == 5:
				$Camera2D/mapbutton.disabled = false
			dialogue_index += 1
			show_next_dialogue()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if SaveManager.cook and SaveManager.captain == false and SaveManager.scrub and SaveManager.feed and SaveManager.sort and SaveManager.fish:
		SaveManager.captain = true
		can_play = true
		$ParrotMG.monitorable = false
		locked = true
		dialogue_index = 3
		$Camera2D/CaptainCat.visible=true
		show_next_dialogue()
		return
	
	
	if movedown == true and locked == false:
		$Camera2D.global_position += Vector2(0, 150) * delta
	$Camera2D.global_position.y = clamp(
		$Camera2D.global_position.y,
		203,
		486
	)
	if moveup == true and locked == false:
		$Camera2D.global_position += Vector2(0, -150) * delta
	$Camera2D.global_position.y = clamp(
		$Camera2D.global_position.y,
		203,
		486
	)

func _on_fontain_play_mouse_entered() -> void:
	$Fontain.play("default")

func _on_fontain_play_mouse_exited() -> void:
	$Fontain.stop()

func _on_birdhouse_play_mouse_entered() -> void:
	$"Bird house".play("default")

func _on_birdhouse_play_mouse_exited() -> void:
	$"Bird house".stop()


func _on_parrot_mg_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		can_play = true
		if SaveManager.feed == false:
			locked = true
			$Camera2D.global_position.y = 485
			dialogue_index = 0
			feeding = true
			show_next_dialogue()
		elif SaveManager.feed == true:
			dialogue_index = 2
			feeding2 = true
			show_next_dialogue()

func _on_move_up_mouse_entered() -> void:
	moveup = true


func _on_move_up_mouse_exited() -> void:
	moveup = false


func _on_move_d_own_mouse_entered() -> void:
	movedown = true


func _on_move_d_own_mouse_exited() -> void:
	movedown = false




func _on_bubble_bucket_mouse_entered() -> void:
	$BubbleBuket.play("default")


func _on_bubble_bucket_mouse_exited() -> void:
	$BubbleBuket.stop()



func _on_side_view_1_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		Global.leftcam = false
		Global.rightcam = true
		get_tree().change_scene_to_file("res://scene/SideShipView1.tscn")

func _on_side_view_2_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		Global.leftcam = true
		Global.rightcam = false
		get_tree().change_scene_to_file("res://scene/SideShipView2.tscn")


func _on_player_button_pressed() -> void:
	if feeding == true and dialogue_index == 1:
		get_tree().change_scene_to_file("res://scene/parrot.tscn")
	dialogue_index += 1
	show_next_dialogue()

func _on_mapbutton_pressed() -> void:
	$Camera2D/mapbutton.visible=false
	$Camera2D/CaptainCat.visible=false
	$ParrotMG.monitorable = true
	locked=false
