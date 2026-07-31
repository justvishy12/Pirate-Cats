extends Node2D
var mos_pos 
var shovel = preload("res://assets/shovel cursor.png")
var one = false
var two = false
var three =false
var four = false
var five = false
var six = false
var sand_scene = preload("res://scene/sand.tscn")
var sponge = preload("res://assets/shovel cursor.png")
var treas = randi_range(1, 6)

var dialogue = [
	{
		#0
		"speaker": "you",
		"name": "",
		"text": "What are we doing here? "
	},
	{
		#1
		"speaker": "cat",
		"name": "Cat Sparrow (Captain)",
		"text": "We? No, you are going to help us dig and find the treasure. ",
		"portrait": preload("res://assets/headshots/CAPTIAN FACE.png")
	},
	{
		#2
		"speaker": "you",
		"name": "",
		"text": "Uhh, how do I do tha- "
	},
	{
		#3
		"speaker": "cat",
		"name": "Cat Sparrow (Captain)",
		"text": "You will use your shovel to dig, and dig in the same spot a few times. ",
		"portrait": preload("res://assets/headshots/CAPTIAN FACE.png")
	},
	{
		#4
		"speaker": "cat",
		"name": "Mopps (Scrubber)",
		"text": "HE ACTUALLY FOUND IT ",
		"portrait": preload("res://assets/headshots/SCRUBBER FACE.png")
	},
	{
		#5
		"speaker": "cat",
		"name": "Mopps (Scrubber)",
		"text": "I dont think it's near the scallops. ",
		"portrait": preload("res://assets/headshots/SCRUBBER FACE.png")
	},
	{
		#6
		"speaker": "cat",
		"name": "Smokey (Powder Monkey)",
		"text": "Probably not near the coconuts. ",
		"portrait": preload("res://assets/headshots/POWDER MONKEY FACE.png")
	},
	{
		#7
		"speaker": "cat",
		"name": "Biscuits (Cook)",
		"text": "No, not near the starfish. ",
		"portrait": preload("res://assets/headshots/CHEF FACE.png")
	},
	{
		#8
		"speaker": "cat",
		"name": "Minnow (Fisher)",
		"text": "Not the shells. ",
		"portrait": preload("res://assets/headshots/FISHER FACE.png")
	},
	{
		#9
		"speaker": "cat",
		"name": "Minnow (Fisher)",
		"text": "I dont think it's here. ",
		"portrait": preload("res://assets/headshots/SCRUBBER FACE.png")
	},
	{
		#10
		"speaker": "cat",
		"name": "Mopps (Scrubber)",
		"text": "You're digging to far out. ",
		"portrait": preload("res://assets/headshots/SCRUBBER FACE.png")
	},
	{
		#11
		"speaker": "cat",
		"name": "Cat Sparrow (Captain)",
		"text": "Well, I'm impressed. ",
		"portrait": preload("res://assets/headshots/CAPTIAN FACE.png")
	},
	{
		#12
		"speaker": "cat",
		"name": "Cat Sparrow (Captain)",
		"text": "What do you say we all have a party on this island? ",
		"portrait": preload("res://assets/headshots/CAPTIAN FACE.png")
	},
	{
		#13
		"speaker": "you",
		"name": "",
		"text": "That sounds fun!"
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
	if dialogue_index == 13:
		get_tree().change_scene_to_file("res://scene/finalscene.tscn")
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
	$Typing.play()
	
	for i in $Textbox/textlabel.text.length():
		if !is_inside_tree():
			return
		$Textbox/textlabel.visible_characters = i
		await get_tree().create_timer(SaveManager.speed, false).timeout
	$Typing.stop()
	typing = false

func _input(event):
	if event.is_action_pressed("ui_accept") and !typing:
		if dialogue_index < dialogue.size() and dialogue[dialogue_index]["speaker"] == "cat":
			print(dialogue_index)
			if dialogue_index == 3:
				print("Hiding panel")
				$Textbox.visible = false
				$Panel.visible = false
			if dialogue_index == 4:
				dialogue_index = 11
				show_next_dialogue()
				return
			elif dialogue_index == 11:
				dialogue_index = 12
				show_next_dialogue()
				return
			elif dialogue_index == 12:
				dialogue_index = 13
				show_next_dialogue()
				return
			if dialogue_index == 0 or dialogue_index == 1 or dialogue_index == 2:
				dialogue_index += 1
				show_next_dialogue()
			else:
				$Textbox.visible = false

func _ready() -> void:
	Input.set_custom_mouse_cursor(sponge)
	show_next_dialogue()

func shells():
	dialogue_index = 5
	show_next_dialogue()
func coconuts():
	dialogue_index = 6
	show_next_dialogue()
func cones():
	dialogue_index = 8
	show_next_dialogue()
func stars():
	dialogue_index = 7
	show_next_dialogue()
func find():
	dialogue_index = 9
	show_next_dialogue()
func treasure():
	SaveManager.island = true
	SaveManager.save_game(SaveManager.current_slot)
	dialogue_index = 4
	show_next_dialogue()


func tres():
	Input.set_custom_mouse_cursor(null)
	$side.disabled = true
	$side2.disabled = true
	$top.disabled = true
	$bottom.disabled = true
	$Button.disabled = true
	$Button2.disabled = true
	$Button3.disabled = true
	$Button4.disabled = true
	$Button5.disabled = true
	$Button6.disabled = true
	dialogue_index = 4
	show_next_dialogue()
func _on_side_pressed() -> void:
	dialogue_index = 10
	show_next_dialogue()
 
func _on_side_2_pressed() -> void:
	dialogue_index = 10
	show_next_dialogue()
 
func _on_top_pressed() -> void:
	dialogue_index = 10
	show_next_dialogue()
 
func _on_bottom_pressed() -> void:
	dialogue_index = 10
	show_next_dialogue()
 
func _on_button_pressed() -> void:
	$Dig.play()
	mos_pos = get_global_mouse_position()
	var sand = sand_scene.instantiate()
	sand.global_position = mos_pos
	add_child(sand)
	sand.coconuts = true
	if treas == 1:
		sand.treasure = true


func _on_button_2_pressed() -> void:
	$Dig.play()
	mos_pos = get_global_mouse_position()
	var sand = sand_scene.instantiate()
	sand.global_position = mos_pos
	add_child(sand)
	sand.shells = true
	if treas == 2:
		sand.treasure = true



func _on_button_3_pressed() -> void:
	$Dig.play()
	mos_pos = get_global_mouse_position()
	var sand = sand_scene.instantiate()
	sand.global_position = mos_pos
	add_child(sand)
	sand.cones = true
	if treas == 3:
		sand.treasure = true



func _on_button_4_pressed() -> void:
	$Dig.play()
	mos_pos = get_global_mouse_position()
	var sand = sand_scene.instantiate()
	sand.global_position = mos_pos
	add_child(sand)
	sand.find = true	
	if treas == 4:
		sand.treasure = true



func _on_button_5_pressed() -> void:
	$Dig.play()
	mos_pos = get_global_mouse_position()
	var sand = sand_scene.instantiate()
	sand.global_position = mos_pos
	sand.coconuts = true
	add_child(sand)
	if treas == 5:
		sand.treasure = true



func _on_button_6_pressed() -> void:
	$Dig.play()
	mos_pos = get_global_mouse_position()
	var sand = sand_scene.instantiate()
	sand.global_position = mos_pos
	sand.stars = true
	add_child(sand)
	if treas == 6:
		sand.treasure = true
