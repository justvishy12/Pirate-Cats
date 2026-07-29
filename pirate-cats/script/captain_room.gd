extends Node2D
var tank_locked = false
var moveleft = false
var moveright = false
var m1 = 0
var m2 = 0
var m3 = 0
var map1 = false
var map2 = false
var map3 = false
var map4 = false
var map5 = false
var map6 = false
var pan1 = false
var pan2 = false
var pan3 = false
var pan4 = false
var pan5 = false
var pan6 = false
var placed1 = false
var placed2 = false
var placed3 = false
var placed4 = false
var placed5 = false
var placed6 = false
var maps = []
var panels = []
var placds = [placed1, placed2, placed3, placed4, placed5, placed6]
@onready var butmap = $Camera2D/bg/Map1
var dragging1 = false
var of1 = Vector2(0,0)
var in_zone1 = false
var dragging2 = false
var of2 = Vector2(0,0)
var in_zone2 = false
var dragging3 = false
var of3 = Vector2(0,0)
var in_zone3 = false
var dragging4 = false
var of4 = Vector2(0,0)
var in_zone4 = false
var dragging5 = false
var of5 = Vector2(0,0)
var in_zone5 = false
var dragging6 = false
var of6 = Vector2(0,0)
var in_zone6 = false
var get_map = false



var dialogue = [
	{
		#0
		"speaker": "cat",
		"name": "Cat Sparrow (Captain)",
		"text": "Assemble the pieces on the desk and let's find some treasure ARR! ",
		"portrait": preload("res://assets/headshots/CAPTIAN FACE.png")
	},
	{
		#1
		"speaker": "cat",
		"name": "Cat Sparrow (Captain)",
		"text": "Hmm I don't remember what it looked like before.",
		"portrait": preload("res://assets/headshots/CAPTIAN FACE.png")
	},
	{
		#2
		"speaker": "cat",
		"name": "Cat Sparrow (Captain)",
		"text": "Maybe try dragging the pieces together?",
		"portrait": preload("res://assets/headshots/CAPTIAN FACE.png")
	},
	{
		#3 
		"speaker": "cat",
		"name": "Cat Sparrow (Captain)",
		"text": "Meet me outside and let's start sailing towards the treasure. ",
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
		#$Button.visible = false
		show_cat_text(line)
		
	#elif line["speaker"] == "event":
		#$Button.visible = false
		#$Textbox.visible = false
		#$AnimationPlayer.play("event")
		#await $AnimationPlayer.animation_finished
		#dialogue_index += 1
		#show_next_dialogue()
		#return
	#elif line["speaker"] == "fadescene":
		#$Button.visible = false
		#$Textbox.visible = false
		#$AnimationPlayer.play("fadescene")
		#await $AnimationPlayer.animation_finished
		#get_tree().change_scene_to_file("res://scene/crab_fight.tscn")

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
			if dialogue_index == 0:
				$Textbox.visible=false
				return
			if dialogue_index == 2:
				$Textbox.visible=false
				return
			dialogue_index += 1
			show_next_dialogue()

func _ready() -> void:
	if SaveManager.cook and SaveManager.captain == true and SaveManager.scrub and SaveManager.feed and SaveManager.sort and SaveManager.fish:
		$CaptainCat.visible=true
		$Area2D/CollisionShape2D.disabled=false
	if SaveManager.fish == false:
		$Camera2D/bg/Map1.disabled = true
		$Camera2D/bg/Map1.visible = true
	if SaveManager.cook == false:
		$Camera2D/bg/Map2.disabled = true
		$Camera2D/bg/Map2.visible = true
	if SaveManager.feed == false:
		$Camera2D/bg/Map3.disabled = true
		$Camera2D/bg/Map3.visible = true
	if SaveManager.sort == false:
		$Camera2D/bg/Map4.disabled = true
		$Camera2D/bg/Map4.visible = true
	if SaveManager.scrub == false:
		$Camera2D/bg/Map5.disabled = true
		$Camera2D/bg/Map5.visible = true
	if SaveManager.captain == false:
		$Camera2D/bg/Map6.disabled = true
		$Camera2D/bg/Map6.visible = true
	Global.leftcam = false
	Global.rightcam = false
	maps = [$Camera2D/bg/Map1, $Camera2D/bg/Map2, $Camera2D/bg/Map3, $Camera2D/bg/Map4, $Camera2D/bg/Map5, $Camera2D/bg/Map6]
	panels = [$Camera2D/bg/PH1, $Camera2D/bg/PH2, $Camera2D/bg/PH3, $Camera2D/bg/PH4, $Camera2D/bg/PH5, $Camera2D/bg/PH6]
func _process(delta: float) -> void:
	if all_maps_placed():
		if map1 and map2 and map3 and map4 and map5 and map6 and get_map == false:
			get_map = true
			allign_map()
		else:
			map1 = false
			map2 = false
			map3 = false
			map4 = false
			map5 = false
			map6 = false
			placed1 = false
			placed2 = false
			placed3 = false
			placed4 = false
			placed5 = false
			placed6 = false
			$Camera2D/bg/Map1.position = Vector2(394, 232)
			$Camera2D/bg/Map2.position = Vector2(423, 152)
			$Camera2D/bg/Map3.position = Vector2(94, 237)
			$Camera2D/bg/Map4.position = Vector2(382, 73)
			$Camera2D/bg/Map5.position = Vector2(65, 154)
			$Camera2D/bg/Map6.position = Vector2(102, 76)


	if dragging1:
		$Camera2D/bg/Map1.position =  $Camera2D/bg.get_local_mouse_position() - of1
	if dragging2:
		$Camera2D/bg/Map2.position =  $Camera2D/bg.get_local_mouse_position() - of2
	if dragging3:
		$Camera2D/bg/Map3.position =  $Camera2D/bg.get_local_mouse_position() - of3
	if dragging4:
		$Camera2D/bg/Map4.position =  $Camera2D/bg.get_local_mouse_position() - of4
	if dragging5:
		$Camera2D/bg/Map5.position =  $Camera2D/bg.get_local_mouse_position() - of5
	if dragging6:
		$Camera2D/bg/Map6.position =  $Camera2D/bg.get_local_mouse_position() - of6
	if moveleft == true:
		$Camera2D.position += Vector2(-150, 0) * delta
	$Camera2D.position.x = clamp(
		$Camera2D.position.x,
		-151,
		151.5
	)
	if moveright == true:
		$Camera2D.position += Vector2(150, 0) * delta
	$Camera2D.position.x = clamp(
		$Camera2D.position.x,
		-151,
		151.5
	)
	
func snap_map(map, panel):
	var panel_center = panel.position + (panel.size / 2)
	map.position = panel_center - (map.size / 2)

func _on_tank_mouse_entered() -> void:
	$JellyFish.play("default")
func _on_tank_mouse_exited() -> void:
	$JellyFish.stop()
func _on_cat_toys_mouse_entered() -> void:
	$CatToy.play("default")
	$CatToy2.play("default")
	$CatToy3.play("default")
func _on_cat_toys_mouse_exited() -> void:
	$CatToy.stop()
	$CatToy2.stop()
	$CatToy3.stop()
func _on_bottle_mouse_entered() -> void:
	$bottle.play("default")
func _on_bottle_mouse_exited() -> void:
	$bottle.stop()
func _on_door_handle_mouse_entered() -> void:
	$doorhandle.play("default")
func _on_door_handle_mouse_exited() -> void:
	$doorhandle.stop()
func _on_cam_left_mouse_entered() -> void:
	moveleft = true
func _on_cam_left_mouse_exited() -> void:
	moveleft = false
func _on_cam_right_mouse_entered() -> void:
	moveright = true
func _on_cam_right_mouse_exited() -> void:
	moveright = false
func _on_back_ship_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and !SaveManager.full_map:
		get_tree().change_scene_to_file("res://scene/Backship.tscn")
	if event is InputEventMouseButton and event.pressed and SaveManager.full_map:
		get_tree().change_scene_to_file("res://scene/starpuzzle.tscn")

func allign_map():
	dialogue_index = 3
	SaveManager.full_map =true
	$Camera2D/bg/Map1.visible = false
	$Camera2D/bg/Map2.visible = false
	$Camera2D/bg/Map3.visible = false
	$Camera2D/bg/Map4.visible = false
	$Camera2D/bg/Map5.visible = false
	$Camera2D/bg/Map6.visible = false
	$Camera2D/bg/MapPieces.visible = true
	await get_tree().create_timer(1).timeout
	show_next_dialogue()
	$CaptainCat.visible=true
	$Camera2D/bg.visible = false
func _on_area_m_1_mouse_entered() -> void:
	if not $m1.is_playing():
		if m1 == 0:
			m1 = 1
			$m1.play("rat1 move")
		else:
			m1 = 0
			$m1.play("rat1 move back")


func _on_area_m_2_mouse_entered() -> void:
	if not $m2.is_playing():
		if m2 == 0:
			m2 = 1
			$m2.play("rat2 move")
		else:
			m2 = 0
			$m2.play("rat2 move back")


func _on_area_m_3_mouse_entered() -> void:
	if not $m3.is_playing():
		if m3 == 0:
			m3 = 1
			$m3.play("rat3 move")
		else:
			m3 = 0
			$m3.play("rat3 move back")


func _on_map_1_button_down() -> void:
	dragging1 = true
	of1 = $Camera2D/bg.get_local_mouse_position() - $Camera2D/bg/Map1.position
	butmap = $Camera2D/bg/Map1
	map1 = false
	placed1 = false
func _on_map_1_button_up() -> void:
	dragging1 = false
	var can_map1 = true
	if $Camera2D/bg/Map1.get_rect().intersects($Camera2D/bg/MPArea.get_rect()):
		var placeholders = [$Camera2D/bg/PH1, $Camera2D/bg/PH2, $Camera2D/bg/PH3, $Camera2D/bg/PH4, $Camera2D/bg/PH5, $Camera2D/bg/PH6]
		var alimaps = [$Camera2D/bg/Map2, $Camera2D/bg/Map3, $Camera2D/bg/Map4, $Camera2D/bg/Map5, $Camera2D/bg/Map6]
		var closest = null
		var closest_dist = INF

		for ph in placeholders:
			var dist = $Camera2D/bg/Map1.position.distance_to(ph.position)

			if dist < closest_dist:
				closest_dist = dist
				closest = ph

		if closest:
			if is_panel_taken(closest, $Camera2D/bg/Map1):
				can_map1 = false
			if can_map1:
				snap_map($Camera2D/bg/Map1, closest)

				if closest == $Camera2D/bg/PH1:
					map1 = true
				else:
					map1 = false
				placed1 = true
			else:
				$Camera2D/bg/Map1.position = Vector2(106,31)
				placed1 = false
	else:		
		map1 = false
		placed1 = false

func _on_map_2_button_down() -> void:
	dragging2 = true
	of2 =  $Camera2D/bg.get_local_mouse_position() - $Camera2D/bg/Map2.position
	butmap = $Camera2D/bg/Map2
	map2 = false
	placed2 = false
func _on_map_2_button_up() -> void:
	dragging2 = false
	var can_map2 = true
	if $Camera2D/bg/Map2.get_rect().intersects($Camera2D/bg/MPArea.get_rect()):
		var placeholders = [$Camera2D/bg/PH1, $Camera2D/bg/PH2, $Camera2D/bg/PH3, $Camera2D/bg/PH4, $Camera2D/bg/PH5, $Camera2D/bg/PH6]
		var alimaps = [$Camera2D/bg/Map1, $Camera2D/bg/Map3, $Camera2D/bg/Map4, $Camera2D/bg/Map5, $Camera2D/bg/Map6]
		var closest = null
		var closest_dist = INF

		for ph in placeholders:
			var dist = $Camera2D/bg/Map2.position.distance_to(ph.position)

			if dist < closest_dist:
				closest_dist = dist
				closest = ph

		if closest:
			if is_panel_taken(closest, $Camera2D/bg/Map2):
				can_map2 = false
			if can_map2:
				snap_map($Camera2D/bg/Map2, closest)

				if closest == $Camera2D/bg/PH2:
					map2 = true
				else:
					map2 = false
				placed2 = true
			else:
				$Camera2D/bg/Map2.position = Vector2(135, -49)
				placed2 = false
	else:
		map2 = false
		placed2 = false
	print(placed2)
func _on_map_3_button_down() -> void:
	dragging3 = true
	of3 =  $Camera2D/bg.get_local_mouse_position() - $Camera2D/bg/Map3.position
	butmap = $Camera2D/bg/Map3
	map3 = false
	placed3 = false
func _on_map_3_button_up() -> void:
	dragging3 = false
	var can_map3 = true
	if $Camera2D/bg/Map3.get_rect().intersects($Camera2D/bg/MPArea.get_rect()):
		var placeholders = [$Camera2D/bg/PH1, $Camera2D/bg/PH2, $Camera2D/bg/PH3, $Camera2D/bg/PH4, $Camera2D/bg/PH5, $Camera2D/bg/PH6]
		var alimaps = [$Camera2D/bg/Map1, $Camera2D/bg/Map2, $Camera2D/bg/Map4, $Camera2D/bg/Map5, $Camera2D/bg/Map6]
		var closest = null
		var closest_dist = INF

		for ph in placeholders:
			var dist = $Camera2D/bg/Map3.position.distance_to(ph.position)

			if dist < closest_dist:
				closest_dist = dist
				closest = ph

		if closest:
			if is_panel_taken(closest, $Camera2D/bg/Map3):
				can_map3 = false
			if can_map3:
				snap_map($Camera2D/bg/Map3, closest)
				
				if closest == $Camera2D/bg/PH3:
					map3 = true
				else:
					map3 = false
				placed3 = true
			else:
				$Camera2D/bg/Map3.position = Vector2(-194, 36)
				placed3 = false
	else:
		map3 = false
		placed3 = false
		
func _on_map_4_button_down() -> void:
	dragging4 = true
	of4 =  $Camera2D/bg.get_local_mouse_position() - $Camera2D/bg/Map4.position
	butmap = $Camera2D/bg/Map4
	map4 = false
	placed4 = false
func _on_map_4_button_up() -> void:
	dragging4 = false
	var can_map4 = true
	if $Camera2D/bg/Map4.get_rect().intersects($Camera2D/bg/MPArea.get_rect()):
		var placeholders = [$Camera2D/bg/PH1, $Camera2D/bg/PH2, $Camera2D/bg/PH3, $Camera2D/bg/PH4, $Camera2D/bg/PH5, $Camera2D/bg/PH6]
		var alimaps = [$Camera2D/bg/Map1, $Camera2D/bg/Map2, $Camera2D/bg/Map3, $Camera2D/bg/Map5, $Camera2D/bg/Map6]
		var closest = null
		var closest_dist = INF

		for ph in placeholders:
			var dist = $Camera2D/bg/Map4.position.distance_to(ph.position)

			if dist < closest_dist:
				closest_dist = dist
				closest = ph

		if closest:
			if is_panel_taken(closest, $Camera2D/bg/Map4):
				can_map4 = false
			if can_map4:
				snap_map($Camera2D/bg/Map4, closest)
	
				if closest == $Camera2D/bg/PH4:
					map4 = true
				else:
					map4 = false
				placed4 = true
			else:
				$Camera2D/bg/Map4.position = Vector2(94, -128)
				placed4 = false
	else:
		map4 = false
		placed4 = false
		
func _on_map_5_button_down() -> void:
	dragging5 = true
	of5 =  $Camera2D/bg.get_local_mouse_position() - $Camera2D/bg/Map5.position
	butmap = $Camera2D/bg/Map5
	map5 = false
	placed5 = false
func _on_map_5_button_up() -> void:
	dragging5 = false
	var can_map5 = true
	if $Camera2D/bg/Map5.get_rect().intersects($Camera2D/bg/MPArea.get_rect()):
		var placeholders = [$Camera2D/bg/PH1, $Camera2D/bg/PH2, $Camera2D/bg/PH3, $Camera2D/bg/PH4, $Camera2D/bg/PH5, $Camera2D/bg/PH6]
		var alimaps = [$Camera2D/bg/Map1, $Camera2D/bg/Map2, $Camera2D/bg/Map3, $Camera2D/bg/Map4, $Camera2D/bg/Map6]
		var closest = null
		var closest_dist = INF

		for ph in placeholders:
			var dist = $Camera2D/bg/Map5.position.distance_to(ph.position)

			if dist < closest_dist:
				closest_dist = dist
				closest = ph

		if closest:
			if is_panel_taken(closest, $Camera2D/bg/Map5):
				can_map5 = false
					
			if can_map5:
				snap_map($Camera2D/bg/Map5, closest)

				if closest == $Camera2D/bg/PH5:
					map5 = true
				else:
					map5 = false
				placed5 = true
			else:
				$Camera2D/bg/Map5.position = Vector2(-223, -47)
				placed5 = false
	else:
		map5 = false
		placed5 = false
		
func _on_map_6_button_down() -> void:
	dragging6 = true
	of6 =  $Camera2D/bg.get_local_mouse_position() - $Camera2D/bg/Map6.position
	butmap = $Camera2D/bg/Map6
	map6 = false
	placed6 = false
func _on_map_6_button_up() -> void:
	dragging6 = false
	var can_map6 = true
	if $Camera2D/bg/Map6.get_rect().intersects($Camera2D/bg/MPArea.get_rect()):
		var placeholders = [$Camera2D/bg/PH1, $Camera2D/bg/PH2, $Camera2D/bg/PH3, $Camera2D/bg/PH4, $Camera2D/bg/PH5, $Camera2D/bg/PH6]
		var alimaps = [$Camera2D/bg/Map1, $Camera2D/bg/Map2, $Camera2D/bg/Map3, $Camera2D/bg/Map4, $Camera2D/bg/Map5]
		var closest = null
		var closest_dist = INF

		for ph in placeholders:
			var dist = $Camera2D/bg/Map6.position.distance_to(ph.position)

			if dist < closest_dist:
				closest_dist = dist
				closest = ph

		if closest:
			if is_panel_taken(closest, $Camera2D/bg/Map6):
				can_map6 = false
					
			if can_map6:
				snap_map($Camera2D/bg/Map6, closest)
				
				if closest == $Camera2D/bg/PH6:
					map6 = true
				else:
					map6 = false
				placed6 = true
			else:
				$Camera2D/bg/Map6.position = Vector2(-186, -125)
				placed6 = false
	else:
		map6 = false
		placed6 = false
		
func is_panel_taken(panel, ignore_map):
	for map in maps:
		if map != ignore_map:
			if map.get_rect().intersects(panel.get_rect()):
				return true

	return false
	
func all_maps_placed():
	return placed1 and placed2 and placed3 and placed4 and placed5 and placed6
	
func _on_table_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.pressed and !SaveManager.full_map:
		dialogue_index =1
		show_next_dialogue()
		$Camera2D/bg.visible = true
		$CaptainCat.visible=false
	#if event is InputEventMouseButton and event.pressed and SaveManager.full_map:
		#
		#$Camera2D/bg.visible=true
		#$Camera2D/bg/table.visible=true
		#$Camera2D/bg/MapPieces.visible =true

func _on_resset_map_pressed() -> void:
	map1 = false
	map2 = false
	map3 = false
	map4 = false	
	map5 = false
	map6 = false	
	placed1 = false
	placed2 = false		
	placed3 = false
	placed4 = false
	placed5 = false
	placed6 = false
	$Camera2D/bg/Map1.position = Vector2(394, 232)
	$Camera2D/bg/Map2.position = Vector2(423, 152)
	$Camera2D/bg/Map3.position = Vector2(94, 237)
	$Camera2D/bg/Map4.position = Vector2(382, 73)
	$Camera2D/bg/Map5.position = Vector2(65, 154)
	$Camera2D/bg/Map6.position = Vector2(102, 76)


func _on_captain_input(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed and !SaveManager.full_map:
		dialogue_index = 0
		show_next_dialogue()
	if event is InputEventMouseButton \
	and event.button_index == MOUSE_BUTTON_LEFT \
	and event.pressed and SaveManager.full_map:
		dialogue_index = 3
		show_next_dialogue()
