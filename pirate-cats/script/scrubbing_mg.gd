extends Node2D
var O1 = false
var O2 = false
var O3 = false

var T1 = false
var T2 = false
var T3 = false
var T4 = false
var T5 = false

var E1 = false
var E2 = false
var E3 = false
var E4 = false
var E5 = false
var E6 = false
var map_dialogue_shown = false
var sponge = preload("res://assets/sponge cursor.png")
var mouse_pos: Vector2


var dialogue = [
	{
		#1
		"speaker": "you",
		"name": "",
		"text": "Uhh, what do I do? "
	},
	{
		#2
		"speaker": "cat",
		"name": "Mopps (Scrubber)",
		"text": "Oh right, hover and move your mouse on the stains to clean them. ",
		"portrait": preload("res://assets/headshots/SCRUBBER FACE.png")
	},
	{
		#3
		"speaker": "cat",
		"name": "Mopps (Scrubber)",
		"text": "They're hard to get out, make sure you're scrubbing on top of them, good luck! ",
		"portrait": preload("res://assets/headshots/SCRUBBER FACE.png")
	},
	{
		#4
		"speaker": "cat",
		"name": "Mopps (Scrubber)",
		"text": "That was there? The captain will be happy! ",
		"portrait": preload("res://assets/headshots/SCRUBBER FACE.png")
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
			if dialogue_index == 2:
				print("Hiding panel")
				$Textbox.visible = false
				$Panel.visible = false
			if dialogue_index == 3:
				get_tree().change_scene_to_file("res://scene/SideShipView2.tscn")
			if dialogue_index != 2:
				dialogue_index += 1
				show_next_dialogue()


func _ready() -> void:
	show_next_dialogue()
	mouse_pos = get_global_mouse_position()
	Input.set_custom_mouse_cursor(sponge)
	round1()

func _process(delta: float) -> void:
	pass

func round1():
	while $Round1/Dirt1.modulate.a > 0.0 or $Round1/Dirt2.modulate.a > 0.0 or $Round1/Dirt3.modulate.a > 0.0:
		var hovering_stain = O1 or O2 or O3 or T1 or T2 or T3 or T4 or T5 or E1 or E2 or E3 or E4 or E5 or E6
		var mouse_moved = mouse_pos.distance_to(get_global_mouse_position()) >= 2

		if not hovering_stain or not mouse_moved:
			$Scrubbing.stop()
		else:
			if !$Scrubbing.playing:
				$Scrubbing.play()
		if $Round1/Dirt3.modulate.a < 0.18:
			$Round1/Dirt3.modulate.a = 0.0
		if O1 == true and mouse_pos.distance_to(get_global_mouse_position()) >= 2:
			$Round1/Dirt1.modulate.a = max(0.0, $Round1/Dirt1.modulate.a - 0.18)
		if O2 == true and mouse_pos.distance_to(get_global_mouse_position()) >= 2:
			$Round1/Dirt2.modulate.a = max(0.0, $Round1/Dirt2.modulate.a - 0.25)
		if O3 == true and mouse_pos.distance_to(get_global_mouse_position()) >= 2:
			$Round1/Dirt3.modulate.a = max(0.0, $Round1/Dirt3.modulate.a - 0.2)
				
		mouse_pos = get_global_mouse_position()
		await get_tree().create_timer(0.4).timeout
	$Scrubbing.stop()
	$Round1.position = Vector2(-816, 383)
	round2()
	$Round2.position = Vector2(0, 0)

func round2():
	while $Round2/Dirt1.modulate.a > 0.0 or $Round2/Dirt2.modulate.a > 0.0 or $Round2/Dirt3.modulate.a > 0.0 and $Round2/Dirt4.modulate.a > 0.0 and $Round2/Dirt5.modulate.a > 0.0:
		var hovering_stain = O1 or O2 or O3 or T1 or T2 or T3 or T4 or T5 or E1 or E2 or E3 or E4 or E5 or E6
		var mouse_moved = mouse_pos.distance_to(get_global_mouse_position()) >= 2

		if not hovering_stain or not mouse_moved:
			$Scrubbing.stop()
		else:
			if !$Scrubbing.playing:
				$Scrubbing.play()
		if T1 == true and mouse_pos.distance_to(get_global_mouse_position()) >= 10:
			$Round2/Dirt1.modulate.a = max(0.0, $Round2/Dirt1.modulate.a - 0.17)
		if T2 == true and mouse_pos.distance_to(get_global_mouse_position()) >= 10:
			$Round2/Dirt2.modulate.a = max(0.0, $Round2/Dirt2.modulate.a - 0.25)
		if T3 == true and mouse_pos.distance_to(get_global_mouse_position()) >= 10:
			$Round2/Dirt3.modulate.a = max(0.0, $Round2/Dirt3.modulate.a - 0.3)
		if T4 == true and mouse_pos.distance_to(get_global_mouse_position()) >= 10:
			$Round2/Dirt4.modulate.a = max(0.0, $Round2/Dirt4.modulate.a - 0.1)
		if T5 == true and mouse_pos.distance_to(get_global_mouse_position()) >= 10:
			$Round2/Dirt5.modulate.a = max(0.0, $Round2/Dirt5.modulate.a - 0.15)
				
		mouse_pos = get_global_mouse_position()
		await get_tree().create_timer(0.4).timeout
	$Scrubbing.stop()
	$Round2.position = Vector2(-816, 383)
	round3()
	$Round3.position = Vector2(0, 0)
func round3():
	while $Round3/Dirt1.modulate.a > 0.0 or $Round3/Dirt2.modulate.a > 0.0 or $Round3/Dirt3.modulate.a > 0.0 and $Round3/Dirt4.modulate.a > 0.0 and $Round3/Dirt5.modulate.a > 0.0 and $Round3/Dirt6.modulate.a > 0.0:
		var hovering_stain = O1 or O2 or O3 or T1 or T2 or T3 or T4 or T5 or E1 or E2 or E3 or E4 or E5 or E6
		var mouse_moved = mouse_pos.distance_to(get_global_mouse_position()) >= 2

		if not hovering_stain or not mouse_moved:
			$Scrubbing.stop()
		else:
			if !$Scrubbing.playing:
				$Scrubbing.play()
		if E1 == true and mouse_pos.distance_to(get_global_mouse_position()) >= 10:
			$Round3/Dirt1.modulate.a = max(0.0, $Round3/Dirt1.modulate.a - 0.17)
		if E2 == true and mouse_pos.distance_to(get_global_mouse_position()) >= 10:
			$Round3/Dirt2.modulate.a = max(0.0, $Round3/Dirt2.modulate.a - 0.25)
		if E3 == true and mouse_pos.distance_to(get_global_mouse_position()) >= 10:
			$Round3/Dirt3.modulate.a = max(0.0, $Round3/Dirt3.modulate.a - 0.4)
		if E4 == true and mouse_pos.distance_to(get_global_mouse_position()) >= 10:
			$Round3/Dirt4.modulate.a = max(0.0, $Round3/Dirt4.modulate.a - 0.1)
		if E5 == true and mouse_pos.distance_to(get_global_mouse_position()) >= 10:
			$Round3/Dirt5.modulate.a = max(0.0, $Round3/Dirt5.modulate.a - 0.15)
		if E6 == true and mouse_pos.distance_to(get_global_mouse_position()) >= 10:
			$Round3/Dirt6.modulate.a = max(0.0, $Round3/Dirt6.modulate.a - 0.15)
				
		mouse_pos = get_global_mouse_position()
		await get_tree().create_timer(0.4).timeout
	$Scrubbing.stop()
	$mapbutton.visible = true
	var tween = create_tween()
	tween.tween_property($mapbutton, "modulate:a", 1.0, 0.5)
	$Round3.position = Vector2(-816, 383)
	Input.set_custom_mouse_cursor(null)
	SaveManager.scrub = true
	SaveManager.save_game(SaveManager.current_slot)
#region Round One Mouse
func _on_o_1_mouse_entered() -> void:
	O1 = true

func _on_o_1_mouse_exited() -> void:
	O1 = false


func _on_o_2_mouse_entered() -> void:
	O2 = true


func _on_o_2_mouse_exited() -> void:
	O2 = false


func _on_o_3_mouse_entered() -> void:
	O3 = true


func _on_o_3_mouse_exited() -> void:
	O3 = false
#endregion


#region Round Two Mouse
func _on_t_1_mouse_entered() -> void:
	T1 = true


func _on_t_1_mouse_exited() -> void:
	T1 = false


func _on_t_2_mouse_entered() -> void:
	T2 = true


func _on_t_2_mouse_exited() -> void:
	T2 = false


func _on_t_3_mouse_entered() -> void:
	T3 = true


func _on_t_3_mouse_exited() -> void:
	T3 = false


func _on_t_4_mouse_entered() -> void:
	T4 = true


func _on_t_4_mouse_exited() -> void:
	T4 = false


func _on_t_5_mouse_entered() -> void:
	T5 = true


func _on_t_5_mouse_exited() -> void:
	T5 = false
#endregion


#region Round Three Mouse
func _on_e_1_mouse_entered() -> void:
	E1 = true


func _on_e_1_mouse_exited() -> void:
	E1 = false


func _on_e_2_mouse_entered() -> void:
	E2 = true

func _on_e_2_mouse_exited() -> void:
	E2 = false


func _on_e_3_mouse_entered() -> void:
	E3 = true


func _on_e_3_mouse_exited() -> void:
	E3 = false


func _on_e_4_mouse_entered() -> void:
	E4 = true


func _on_e_4_mouse_exited() -> void:
	E4 = false


func _on_e_5_mouse_entered() -> void:
	E5 = true


func _on_e_5_mouse_exited() -> void:
	E5 = false


func _on_e_6_mouse_entered() -> void:
	E6 = true


func _on_e_6_mouse_exited() -> void:
	E6 = false
#endregion


func _on_mapbutton_pressed() -> void:
	if !map_dialogue_shown:
		map_dialogue_shown = true
		dialogue_index = 3
		show_next_dialogue()
