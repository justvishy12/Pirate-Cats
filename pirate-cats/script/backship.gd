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
		"name": "Minnow (Fisher)",
		"text": "Oh hey! I was just about to catch some fish.",
		"portrait": preload("res://assets/headshots/FISHER FACE.png")
	},
	{
		#2
		"speaker": "cat",
		"name": "Minnow (Fisher)",
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
		"name": "Minnow (Fisher)",
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
		"name": "Biscuits (Cook)",
		"text": "Let teach you my secrets ",
		"portrait": preload("res://assets/headshots/CHEF FACE.png")
	},

#If player has  done cooking puzzle:
	{
		#7
		"speaker": "cat",
		"name": "Biscuits (Cook)",
		"text": "Come back for supper! ",
		"portrait": preload("res://assets/headshots/CHEF FACE.png")
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


var dialogue_index = 8
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
		$Camera2D/Textbox.visible=true
		show_cat_text(line)



func _on_player_button_pressed() -> void:
	if SaveManager.fish == false and dialogue_index == 3:
		get_tree().change_scene_to_file("res://scene/fishing.tscn")
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
	$Typing.play()
	for i in $Camera2D/Textbox/textlabel.text.length():
		if !is_inside_tree():
			return
		$Camera2D/Textbox/textlabel.visible_characters = i
		await get_tree().create_timer(SaveManager.speed, false).timeout
	$Typing.stop()
	typing = false

func _input(event):
	if event.is_action_pressed("ui_accept") and !typing:
		if dialogue_index < dialogue.size() and dialogue[dialogue_index]["speaker"] == "cat":
			if SaveManager.fish == false and dialogue_index == 3:
				get_tree().change_scene_to_file("res://scene/fishing.tscn")
			if SaveManager.fish and dialogue_index == 4:
				$Camera2D/Textbox.visible = false
				fishing2 = false
				locked = false
			if SaveManager.cook == false and dialogue_index == 6:
				get_tree().change_scene_to_file("res://scene/cooking.tscn")
			if SaveManager.cook == true and dialogue_index == 7:
				cooking2 = true
				$Camera2D/Textbox.visible = false
				locked = false
			if dialogue_index == 9:
				$Camera2D/mapbutton.visible=true
			if dialogue_index == 10:
				$Camera2D/mapbutton.disabled = false
			if dialogue_index not in [3, 4, 6, 7]:
				dialogue_index += 1
				show_next_dialogue()

func _ready() -> void:
	if Global.rightcam == true:
		$Camera2D.position.x = 351
	elif Global.leftcam == true:
		$Camera2D.position.x = 876

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if SaveManager.cook and SaveManager.captain == false and SaveManager.scrub and SaveManager.feed and SaveManager.sort and SaveManager.fish:
		SaveManager.captain = true
		$Cook.monitorable = false
		locked = true
		dialogue_index = 8
		$Camera2D/CaptainCat.visible=true
		show_next_dialogue()
		return
	
	
	
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
	if SaveManager.fish == true: 
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
		if SaveManager.fish == false:
			fishing = true
			dialogue_index = 0
			show_next_dialogue()
		elif SaveManager.fish == true:
			fishing2 = true
			dialogue_index = 4
			show_next_dialogue()


func _on_cooking_mg_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed:
		locked = true
		$Camera2D.global_position.x = 876.5
		if SaveManager.cook   == false:
			cooking = true
			dialogue_index = 5
			show_next_dialogue()
		elif SaveManager.cook  == true:
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


func _on_mapbutton_pressed() -> void:
	$Camera2D/mapbutton.visible=false
	$Camera2D/CaptainCat.visible=false
	$Cook.monitorable = true
	locked=false
	
