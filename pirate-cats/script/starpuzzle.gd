extends Node2D
var leftside = false
var rightside = false
var round1 = false
var round2 = false
var round3 = false
var r1d = false
var r2d = false
var r3d = false
var roundS = false
var p1 = false
var p2 = false
var p3 = false
var round1done = false
var round2done = false
var got_wrong = false
var round3done = false
var side_movement = 0
var hello = false

var game_finished = false
var map_dialogue_shown = false
var dialogue = [
	{
		#0
		"speaker": "you",
		"name": "",
		"text": "The sky is so pretty. "
	},
	{
		#1
		"speaker": "cat",
		"name": "Cat Sparrow (Captain)",
		"text": "The sky will help us find the treasure and so will you! ",
		"portrait": preload("res://assets/headshots/CAPTIAN FACE.png")
	},
	{
		#2
		"speaker": "you",
		"name": "",
		"text": "Me? What can I do? "
	},
	{
		#3
		"speaker": "cat",
		"name": "Cat Sparrow (Captain)",
		"text": "Hover over the cat related stars so we can steer there. ",
		"portrait": preload("res://assets/headshots/CAPTIAN FACE.png")
	},
	{ 
		#4
		"speaker": "cat",
		"name": "Cat Sparrow (Captain)",
		"text": "If you can do this, our treasure will be here... ",
		"portrait": preload("res://assets/headshots/CAPTIAN FACE.png")
	},
	{ 
		#5
		"speaker": "cat",
		"name": "Cat Sparrow (Captain)",
		"text": "Wait a second, is that... ",
		"portrait": preload("res://assets/headshots/CAPTIAN FACE.png")
	},
	{ 
		#6
		"speaker": "cat",
		"name": "Cat Sparrow (Captain)",
		"text": "It's the island! ",
		"portrait": preload("res://assets/headshots/CAPTIAN FACE.png")
	},
	{ 
		#7
		"speaker": "cat",
		"name": "Cat Sparrow (Captain)",
		"text": "Yawn, It's getting late. Let's sail again tommorow. ",
		"portrait": preload("res://assets/headshots/CAPTIAN FACE.png")
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
	
	for i in $Textbox/textlabel.text.length():
		$Textbox/textlabel.visible_characters = i
		await get_tree().create_timer(0.05).timeout
	
	typing = false

func _input(event):
	if event.is_action_pressed("ui_accept") and !typing:
		if dialogue_index < dialogue.size() and dialogue[dialogue_index]["speaker"] == "cat":
			if dialogue_index == 7 and got_wrong:
				$AnimationPlayer.play("fadein")
				await$AnimationPlayer.animation_finished
				$BackshipViewNight.visible=false
				$Textbox.visible=false
				got_wrong=false
				$AnimationPlayer.play("fadeout")
				await$AnimationPlayer.animation_finished
				game_finished = false
				round1 = false
				round2 = false
				round3 = false

				return

			if dialogue_index == 5:
				$IslandInDistance.visible = false
			if dialogue_index == 6:
				$Textbox.visible = false
				get_tree().change_scene_to_file("res://scene/sand.tscn")
				
			if dialogue_index == 4:
				print("Hiding panel")
				$Textbox.visible = false
				round_finished()
			if dialogue_index != 4:
				dialogue_index += 1
				show_next_dialogue()

func _ready() -> void:
	show_next_dialogue()
	pass

func round_finished():
	await get_tree().create_timer(0.4).timeout
	if round1 == false:
		roundS = true
		$AnimationPlayer.play("ButtonIn")
	elif round1 == true and round2 == false:
		roundS = true
		$Timer.stop()
		$AnimationPlayer.play("ButtonIn")
	elif round2 == true and round3 == false:
		roundS = true
		$Timer.stop()
		$AnimationPlayer.play("ButtonIn")
	if round3 == true and got_wrong:
		$AnimationPlayer.play("fadein")
		await $AnimationPlayer.animation_finished
		$BackshipViewNight.visible=true
		$AnimationPlayer.play("fadeout")
		await $AnimationPlayer.animation_finished
		dialogue_index = 6
		show_next_dialogue()
	if round3 == true and hello == false:
		hello = true
		dialogue_index = 5
		show_next_dialogue()
	if got_wrong:
		print("Player made at least one mistake.")
	else:
		print("Player got every constellation correct!")
func _process(delta: float) -> void:
	if side_movement == 1 and  roundS == false and game_finished == false:
		$Wheel.rotation += -1.0 * delta
	if side_movement == 2 and roundS == false and game_finished == false:
		$Wheel.rotation += 1.0 * delta
	
#region Setup
	if roundS == true:
		side_movement = 0
		if round1 == false:
			$PawprintConstellation.global_position.x = 199
			$ShirtConstellation.global_position.x = 934
			$PawprintConstellation.modulate.a = min(1.0, $PawprintConstellation.modulate.a + delta)
			$ShirtConstellation.modulate.a = min(1.0, $ShirtConstellation.modulate.a + delta)

			if $PawprintConstellation.modulate.a >= 1.0 and $ShirtConstellation.modulate.a >= 1.0:
				roundS = false
				
		elif round2 == false:
			$BootConstellation.global_position.x = 182
			$CatFaceConstellation.global_position.x = 942
			$BootConstellation.modulate.a = min(1.0, $BootConstellation.modulate.a + delta)
			$CatFaceConstellation.modulate.a = min(1.0, $CatFaceConstellation.modulate.a + delta)

			if $BootConstellation.modulate.a >= 1.0 and $CatFaceConstellation.modulate.a >= 1.0:
				roundS = false
				
		elif round3 == false:
			$FishConstellation.global_position.x = 197
			$PantsConstellation.global_position.x = 944
			$FishConstellation.modulate.a = min(1.0, $FishConstellation.modulate.a + delta)
			$PantsConstellation.modulate.a = min(1.0, $PantsConstellation.modulate.a + delta)

			if $PantsConstellation.modulate.a >= 1.0 and $PantsConstellation.modulate.a >= 1.0:
				roundS = false
#endregion
	
	
	
#region Fading DOne
		
	if $PawprintConstellation.global_position.x >= 575:
		$PawprintConstellation.modulate.a = max(0.0, $PawprintConstellation.modulate.a - delta)
		if $PawprintConstellation.modulate.a <= 0.0 and p1 == false:
			round1done = true
			$Wheel.rotation += -2.0 * delta
			p1 = true
			round1 = true
			round_finished()
		
	if $ShirtConstellation.global_position.x <= 575:
		$ShirtConstellation.modulate.a = max(0.0, $ShirtConstellation.modulate.a - delta)
		if $ShirtConstellation.modulate.a <= 0.0 and p1 == false:
			got_wrong = true
			round1done = true
			$Wheel.rotation += 2.0 * delta
			p1 = true
			round1 = true
			round_finished()
		

		
	if $BootConstellation.global_position.x >= 575:
		$BootConstellation.modulate.a = max(0.0,  $BootConstellation.modulate.a - delta)
		if $BootConstellation.modulate.a <= 0.0 and p2== false:
			got_wrong = true
			round2done = true
			$Wheel.rotation += -2.0 * delta
			p2 = true
			round2 = true
			round_finished()

	if $CatFaceConstellation.global_position.x <= 575:
		$CatFaceConstellation.modulate.a = max(0.0, $CatFaceConstellation.modulate.a - delta)
		if $CatFaceConstellation.modulate.a <= 0.0 and p2 == false:
			round2done = true
			$Wheel.rotation += 2.0 * delta
			p2 = true
			round2 = true
			round_finished()

	if $FishConstellation.global_position.x >= 575:
		$FishConstellation.modulate.a = max(0.0,  $FishConstellation.modulate.a - delta)
		if $FishConstellation.modulate.a <= 0.0 and p3 == false:
			round3done = true
			$Wheel.rotation += -2.0 * delta
			p3 = true
			round3 = true
			round_finished()

	if $PantsConstellation.global_position.x <= 575:
		$PantsConstellation.modulate.a = max(0.0, $PantsConstellation.modulate.a - delta)
		if $PantsConstellation.modulate.a <= 0.0 and p3 == false:
			got_wrong = true
			round3done = true
			$Wheel.rotation += 2.0 * delta
			p3 = true
			round3 = true
			round_finished()
#endregion

		
		
#region Movement
	if round1 == true and round2 == false  and round1done == false:
		print( $PawprintConstellation.global_position.x)
		if side_movement == 1 and $PawprintConstellation.global_position.x <= 575:
			$PawprintConstellation.global_position += Vector2(150, 0) * delta
			$ShirtConstellation.global_position += Vector2(150, 0) * delta

		elif side_movement == 2 and $ShirtConstellation.global_position.x >= 575:
			print( $ShirtConstellation.global_position.x)
			$ShirtConstellation.global_position += Vector2(-150, 0) * delta
			$PawprintConstellation.global_position += Vector2(-150, 0) * delta

				
				
	if round2 == true and round3 == false  and round2done == false:
		if side_movement == 1 and $BootConstellation.global_position.x <= 575:
			$BootConstellation.global_position += Vector2(150, 0) * delta
			$CatFaceConstellation.global_position += Vector2(150, 0) * delta

		elif  side_movement == 2 and $CatFaceConstellation.global_position.x >= 575:
			$CatFaceConstellation.global_position += Vector2(-150, 0) * delta
			$BootConstellation.global_position += Vector2(-150, 0) * delta
		
				
	if round3 == true and round3done == false:
		if side_movement == 1 and $FishConstellation.global_position.x <= 575:
			$FishConstellation.global_position += Vector2(150, 0) * delta
			$PantsConstellation.global_position += Vector2(150, 0) * delta

		elif side_movement == 2 and $PantsConstellation.global_position.x >= 575:
			$PantsConstellation.global_position += Vector2(-150, 0) * delta
			$FishConstellation.global_position += Vector2(-150, 0) * delta
#endregion

#region Left and Right
func _on_left_side_mouse_entered() -> void:
	leftside = true
	$Timer.start()



func _on_left_side_mouse_exited() -> void:
	leftside = false
	$Timer.stop()

func _on_right_side_mouse_entered() -> void:
	rightside = true
	$Timer.start()

func _on_right_side_mouse_exited() -> void:
	rightside = false
	$Timer.stop()
#endregion

func _on_timer_timeout() -> void:
	$Timer.stop()
	if round1 == false:
		if leftside:
			side_movement = 1
		elif rightside:
			side_movement = 2
		leftside = false
		rightside = false
		round1 = true
		p1 = false
	elif round2 == false:
		if leftside:
			side_movement = 1
		elif rightside:
			side_movement = 2
		leftside = false
		rightside = false
		round2 = true
		p2 = false
	elif round3 == false:
		if leftside:
			side_movement = 1
		elif rightside:
			side_movement = 2
		leftside = false
		rightside = false
		round3 = true
		p3 = false
