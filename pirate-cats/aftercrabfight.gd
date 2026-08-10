extends Node2D
var skip_typing = true
var dialogue = [
	{
		#0
		"speaker": "cat",
		"name":"Cat Sparrow (Captain)",
		"text": "Thanks for your help. ",
		"portrait": preload("res://assets/headshots/CAPTIAN FACE.png")
	},
{
		#1
		"speaker": "you",
		"name":"",
		"text": "No problem!",
	},
	{
		#2
		"speaker": "cat",
		"name":"Cat Sparrow (Captain)",
		"text": "You could be useful... ",
		"portrait": preload("res://assets/headshots/CAPTIAN FACE.png")
	},
	{
		#3
		"speaker": "cat",
		"name":"Cat Sparrow (Captain)",
		"text": "We're on the hunt for treasure, but we lost the map. ",
		"portrait": preload("res://assets/headshots/CAPTIAN FACE.png")
	},
	{
		#4
		"speaker": "cat",
		"name":"Cat Sparrow (Captain)",
		"text": "Can you help us find it? ",
		"portrait": preload("res://assets/headshots/CAPTIAN FACE.png")
	},
	{
		#5
		"speaker": "you",
		"name":"",
		"text": "Yes of course!",
	},
	{
		#6
		"speaker": "cat",
		"name":"Cat Sparrow (Captain)",
		"text": "Alright, if you find any pieces on this boat, bring them to my cabin.",
		"portrait": preload("res://assets/headshots/CAPTIAN FACE.png")
	},
	{
		#5
		"speaker": "fadescene",
		"name":"",
		"text": "",
	},
]	

var dialogue_index = 0
var typing = false

func _ready() -> void:
	SaveManager.save_game(SaveManager.current_slot)
	show_next_dialogue()

func show_next_dialogue() -> void:
	if dialogue_index >= dialogue.size():
		$Textbox.visible = false
		$Button.visible = false
		return
	
	var line = dialogue[dialogue_index]
	
	if line["speaker"] == "you":
		$Textbox.visible = false
		$Button.visible = true
		$Button.text = line["text"]
		
	elif line["speaker"] == "cat":
		$Button.visible = false
		show_cat_text(line)
		
	elif line["speaker"] == "crabpan":
		$Button.visible = false
		$Textbox.visible = false
		$AnimationPlayer.play("pan crab")
		await $AnimationPlayer.animation_finished
		dialogue_index += 1
		show_next_dialogue()
		return
	elif line["speaker"] == "crabpanback":
		$Button.visible = false
		$Textbox.visible = false
		$AnimationPlayer.play("crabpanback")
		await $AnimationPlayer.animation_finished
		dialogue_index += 1
		show_next_dialogue()
		return
	elif line["speaker"] == "fadescene":
		$Button.visible = false
		$Textbox.visible = false
		$AnimationPlayer.play("fadescene")
		await $AnimationPlayer.animation_finished
		SaveManager.aftercrab = false
		get_tree().change_scene_to_file("res://scene/FrontShip.tscn")

func _on_player_button_pressed() -> void:
	dialogue_index += 1
	show_next_dialogue()

func show_cat_text(line) -> void:
	skip_typing = false
	$Textbox.visible = true
	typing = true
	
	$Textbox/namelabel.text = line["name"]
	$Textbox/textlabel.text = line["text"]
	
	if dialogue_index == 3:
		$AnimationPlayer.play("powder monkey show")
	if dialogue_index == 5:
		$AnimationPlayer.play("scrubber show")
	if dialogue_index == 7:
		$AnimationPlayer.play("chef show")
	if dialogue_index == 9:
		$AnimationPlayer.play("fisher show")
	if dialogue_index ==11:
		$AnimationPlayer.play("captain show")
		$parallaxbg/Camera2D.apply_shake(0.5)
	if dialogue_index ==11:
		$AnimationPlayer.play("captain show")
		$parallaxbg/Camera2D.apply_shake(0.5)
	if line.has("portrait"):
		$Textbox/photobox.texture = line["portrait"]
	else:
		$Textbox/photobox.texture = null
	$Textbox/textlabel.visible_characters = 0
	$Typing.play()
	for i in $Textbox/textlabel.text.length():
		if skip_typing:
			$Textbox/textlabel.visible_characters = $Textbox/textlabel.text.length()
			break
		if !is_inside_tree():
			return
		$Textbox/textlabel.visible_characters = i
		await get_tree().create_timer(SaveManager.speed, false).timeout
	$Typing.stop()
	typing = false


func _input(event):
	if event.is_action_pressed("ui_accept") and !typing:
		if dialogue_index < dialogue.size() and dialogue[dialogue_index]["speaker"] == "cat":
			dialogue_index += 1
			show_next_dialogue()
	elif event.is_action_pressed("ui_accept") and typing:
		skip_typing = true
		$Textbox/textlabel.visible_characters = $Textbox/textlabel.text.length()
