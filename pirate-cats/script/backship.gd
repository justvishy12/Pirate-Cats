extends Node2D
var moveleft = false
var moveright = false
var playing_dialogue = false
var cooking = false
var fishing = false
var cooking2 = false
var fishing2 = false
var locked = false

var dialogue = [
#If player hasn’t done fishing puzzle

	{
		#0
		"speaker": "you",
		"name": "",
		"text": "What are you doing? "
	},

	{
		#1
		"speaker": "cat",
		"name": "Fisher",
		"text": "Oh hey! I was just about to catch some fish.",
		"portrait": preload("res://assets/headshots/FISHER FACE.png")
	},
	{
		#2
		"speaker": "cat",
		"name": "Fisher",
		"text": "Do you want to join? ",
		"portrait": preload("res://assets/headshots/FISHER FACE.png")
	},
	{
		#3
		"speaker": "you",
		"name": "",
		"text": "Sure! "
	},

#If player has done the fishing puzzle

	{
		#4
		"speaker": "cat",
		"name": "Fisher",
		"text": "Nice catch! I’ve never seen a golden fish before. ",
		"portrait": preload("res://assets/headshots/FISHER FACE.png")
	},

#If player hasn’t done cooking puzzle:
	{
		#5
		"speaker": "you",
		"name": "",
		"text": "Ooo, smells lovely here!"
	},
	{
		#6
		"speaker": "cat",
		"name": "Cook",
		"text": "Let teach you my secrets",
		"portrait": preload("res://assets/headshots/FISHER FACE.png")
	},

#If player has  done cooking puzzle:
	{
		#7
		"speaker": "cat",
		"name": "Cook",
		"text": "Come back for supper!",
		"portrait": preload("res://assets/headshots/CHEF FACE.png")
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



func _on_player_button_pressed() -> void:
	dialogue_index += 1
	show_next_dialogue()

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
		await get_tree().create_timer(0.05).timeout
	
	typing = false

func _input(event):
	if event.is_action_pressed("ui_accept") and !typing:
		if dialogue_index < dialogue.size() and dialogue[dialogue_index]["speaker"] == "cat":
			if fishing == true and dialogue_index == 3:
				get_tree().change_scene_to_file("res://scene/fishing.tscn")
			if fishing2 == true and dialogue_index == 4:
				$Camera2D/Textbox.visible = false
				fishing2 = false
				locked = false
			if cooking == true and dialogue_index == 6:
				get_tree().change_scene_to_file("res://scene/cooking.tscn")
			if cooking2 == true and dialogue_index == 7:
				cooking2 = true
				$Camera2D/Textbox.visible = false
				locked = false
			dialogue_index += 1
			show_next_dialogue()

func _ready() -> void:
	if Global.rightcam == true:
		$Camera2D.position.x = 351
	elif Global.leftcam == true:
		$Camera2D.position.x = 876

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if moveleft == true and locked == false:
		$Camera2D.global_position += Vector2(-150, 0) * delta
	$Camera2D.global_position.x = clamp(
		$Camera2D.global_position.x,
		351,
		876.5
	)
	if moveright == true and locked == false:
		$Camera2D.global_position += Vector2(150, 0) * delta
	$Camera2D.global_position.x = clamp(
		$Camera2D.global_position.x,
		351,
		876.5
	)

func _on_cam_left_mouse_entered() -> void:
	moveleft = true
func _on_cam_left_mouse_exited() -> void:
	moveleft = false
func _on_cam_right_mouse_entered() -> void:
	moveright = true
func _on_cam_right_mouse_exited() -> void:
	moveright = false

func _on_fish_mouse_entered() -> void:
	if SaveManager.fish_played == true:
		$fish.play("have_fish")
	else:
		$fish.play("default")
func _on_fish_mouse_exited() -> void:
	$fish.stop()

func _on_cook_mouse_entered() -> void:
	$pan.play("default")
func _on_cook_mouse_exited() -> void:
	$pan.stop()


func _on_fishing_mg_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		locked = true
		$Camera2D.global_position.x = 351
		if Global.fish == false:
			fishing = true
			dialogue_index = 0
			show_next_dialogue()
		elif Global.fish == true:
			fishing2 = true
			dialogue_index = 4
			show_next_dialogue()


func _on_cooking_mg_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		locked = true
		$Camera2D.global_position.x = 876.5
		if Global.cook == false:
			cooking = true
			dialogue_index = 5
			show_next_dialogue()
		elif Global.cook == true:
			cooking2 = true
			dialogue_index = 7
			show_next_dialogue()


func _on_captain_mg_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		get_tree().change_scene_to_file("res://scene/Captain Room.tscn")


func _on_side_ship_view_1_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		Global.leftcam = true
		Global.rightcam = false
		
		get_tree().change_scene_to_file("res://scene/SideShipView1.tscn")
	

func _on_captains_room_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		get_tree().change_scene_to_file("res://scene/Captain Room.tscn")


func _on_side_ship_view_2_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		Global.rightcam = true
		Global.leftcam = false
		get_tree().change_scene_to_file("res://scene/SideShipView2.tscn")
