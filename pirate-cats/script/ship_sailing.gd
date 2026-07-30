extends Node2D

var dialogue = [
	{
		#0
		"speaker": "you",
		"name": "",
		"text": "..."
	},
	{
		#1
		"speaker": "you",
		"name": "",
		"text": "Where am I?"
	},
	{
		#2
		"speaker": "cat",
		"name": "???",
		"text": "HEY!!! ",
		"portrait":null
	},
	{
		#3
		"speaker": "cat",
		"name": "Smokey (Powder Monkey)",
		"text": "Why are you on our ship? ",
		"portrait": preload("res://assets/headshots/POWDER MONKEY FACE.png")
	},
	{
		#4
		"speaker": "you",
		"name":"",
		"text": "Did you catnap me?",
	},
	{
		#5
		"speaker": "cat",
		"name":"Mopps (Scrubber)",
		"text": "Do we look like we'd catnap you? ",
		"portrait": preload("res://assets/headshots/SCRUBBER FACE.png")
	},
	{
		#6
		"speaker": "you",
		"name":"",
		"text": "maybe?..",
	},
	{
		#7
		"speaker": "cat",
		"name":"Biscuits (Chef)",
		"text": "Don't scare the human, guys. ",
		"portrait": preload("res://assets/headshots/CHEF FACE.png")
	},
	{
		#8
		"speaker": "cat",
		"name":"Biscuits (Chef)",
		"text": "Let me cook something for you. ",
		"portrait": preload("res://assets/headshots/CHEF FACE.png")
	},
	{
		#9
		"speaker": "cat",
		"name":"Minnow (Fisher)",
		"text": "OOO I'll catch some fish for the meal! ",
		"portrait": preload("res://assets/headshots/FISHER FACE.png")
	},
	{
		#10
		"speaker": "cat",
		"name":"???",
		"text": "I'll tell you what I'm confused about... ",
	},
	{
		#11
		"speaker": "cat",
		"name":"Cat Sparrow (Captain)",
		"text": "WHAT ARE YOU DOIN ON MY SHIP? ",
		"portrait": preload("res://assets/headshots/CAPTIAN FACE.png")
	},
	{
		#12
		"speaker": "you",
		"name":"",
		"text": "...",
	},
	{
		#13
		"speaker": "you",
		"name":"",
		"text": "Spare me!",
	},
	{
		#14
		"speaker": "you",
		"name":"",
		"text": "I don't know how I got here",
	},
	{
		#15
		"speaker": "crabpan",
		"name":"",
		"text": "",
	},
	{
		#16
		"speaker": "cat",
		"name":"Cat Sparrow (Captain)",
		"text": "We'll discuss this later, looks like we have bigger problems. ",
		"portrait": preload("res://assets/headshots/CAPTIAN FACE.png")
	
	},
	{
		#17
		"speaker": "crabpanback",
		"name":"",
		"text": "",
	},
	{
		#18
		"speaker": "cat",
		"name":"Cat Sparrow (Captain)",
		"text": "I know we just met, but... ",
		"portrait": preload("res://assets/headshots/CAPTIAN FACE.png")
		#pan to crabs throwing thingd
	},
	{#19
		"speaker": "cat",
		"name":"Cat Sparrow (Captain)",
		"text": "Can you help us get rid of those crabs? ",
		"portrait": preload("res://assets/headshots/CAPTIAN FACE.png")
	},
	{
		#20
		"speaker": "you",
		"name":"",
		"text": "I'll try my best?..",
	},
	{
		#21
		"speaker": "cat",
		"name": "Smokey (Powder Monkey)",
		"text": "Quick, lemme show you how to blast them! ",
		"portrait": preload("res://assets/headshots/POWDER MONKEY FACE.png")
	},
	{
		#22
		"speaker": "fadescene",
		"name":"",
		"text": "",
	},
	]

var dialogue_index = 0
var typing = false

func _ready() -> void:
	SaveManager.save_game(SaveManager.current_slot)
	$AnimationPlayer.play("boat craddle")
	await $AnimationPlayer.animation_finished
	$AnimationPlayer.play("showcats")
	await $AnimationPlayer.animation_finished
	$Button.visible=true

func _on_button_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/loading.tscn")

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
		get_tree().change_scene_to_file("res://scene/crab_fight.tscn")

func _on_player_button_pressed() -> void:
	dialogue_index += 1
	show_next_dialogue()

func show_cat_text(line) -> void:
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
		$Camera2D.apply_shake(0.5)
	if dialogue_index ==11:
		$AnimationPlayer.play("captain show")
		$Camera2D.apply_shake(0.5)
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
			dialogue_index += 1
			show_next_dialogue()
