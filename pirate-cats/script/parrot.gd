extends Node2D
var eating = false
var map_dialogue_shown = false
var dialogue=[
	{
		#1
		"speaker": "cat",
		"name": "Polly (Parrot)",
		"text": "No sharing, this is captain level food!",
		"portrait": preload("res://assets/bird.png")
	},
	{
		#2
		"speaker": "cat",
		"name": "Polly (Parrot)",
		"text": "Squawk! Snack time! Thank you, friend! !",
		"portrait": preload("res://assets/bird.png")
	},
	{
		#3
		"speaker": "cat",
		"name": "Polly (Parrot)",
		"text": "Arrr! A fine feast for a fine bird! ",
		"portrait": preload("res://assets/bird.png")
	},
	{
		#4
		"speaker": "cat",
		"name": "Polly (Parrot)",
		"text": "Do parrots dream of giant crackers? ",
		"portrait": preload("res://assets/bird.png")
	},
	{
		#5
		"speaker": "cat",
		"name": "Polly (Parrot)",
		"text": "My tummy says thank you! Squawk  ",
		"portrait": preload("res://assets/bird.png")
	},
	{ #for the map piece
		#6
		"speaker": "cat",
		"name": "Polly (Parrot)",
		"text": "Polly saved this for you! Good bird, right?  ",
		"portrait": preload("res://assets/bird.png")
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
		$Camera2D/Textbox/textlabel.visible_characters = i
		await get_tree().create_timer(0.05).timeout
	
	typing = false


func _input(event):
	if event.is_action_pressed("ui_accept") and !typing:
		if dialogue_index < dialogue.size() and dialogue[dialogue_index]["speaker"] == "cat":
			$Camera2D/Textbox.visible = false

func _on_mapbutton_pressed() -> void:
	get_tree().change_scene_to_file("res://scene/FrontShip.tscn")

func parrot_eat():
	if eating == false:
		var text = randi_range(0, 4)
		dialogue_index = text
		show_next_dialogue()
		eating = true
		$Parrot.play("eating")
		await get_tree().create_timer(2).timeout
		$Parrot.play("default")
		eating = false

func _ready() -> void:
	$mapbutton.modulate.a = 0.0
	$mapbutton.visible = false
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if $Right/Cookie2.visible == false and $Right/Cookie1.visible == false and $Right/Cookie.visible == false and $Left/Cookie5.visible == false and $Left/Cookie4.visible == false and $Left/Cookie3.visible == false and $Left/Cookie6.visible == false and map_dialogue_shown == false:
		print("worked")
		map_dialogue_shown = true
		dialogue_index = 5
		show_next_dialogue()
		$mapbutton.visible = true
		var tween = create_tween()
		tween.tween_property($mapbutton, "modulate:a", 1.0, 0.5)
