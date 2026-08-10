extends Node2D
var CMid = 0
var CLeft = 0
var CRight = 0
var purp = 0
var green = 1
var yellow = 2
var C1_touchable = false
var C2_touchable = false
var C3_touchable = false
var crab_finished = false
var cancel_crabmove = false
var cancel_crabmove2 = false
var cancel_crabmove3 = false
var spawning_crabs = false
var playing_mg = false
var moving = false
var rounds = 0
var can_play = false
var can_shoot = true
var skip_typing = false
var gone_1 = false
var gone_2 = false
var gone_3 = false
const CannonBallScene = preload("res://scene/Cannon Ball.tscn")
const explode = preload("res://scene/explosion.tscn")
@onready var mid_start: Vector2 = $CMid.global_position
@onready var left_start = $CLeft.global_position
@onready var right_start = $CRight.global_position

var dialogue = [
{
		#0
	"speaker": "you",
	"name":"",
	"text": "How do I help?",
},
	{
		#1
		"speaker": "cat",
		"name":"Smokey (Powder Monkey)",
		"text": "You can move the cannons with arrow keys and press space to shoot! ",
		"portrait": preload("res://assets/headshots/POWDER MONKEY FACE.png")
	},
	{
		#2
		"speaker": "cat",
		"name":"Smokey (Powder Monkey)",
		"text": "Good luck, we are counting on you~ ",
		"portrait": preload("res://assets/headshots/POWDER MONKEY FACE.png")
	},
	{
		#3
		"speaker": "event",
		"name":"",
		"text": " ",
	},
	{
		#4
		"speaker": "cat",
		"name":"Smokey (Powder Monkey)",
		"text": "Woah, you defeated them all!",
		"portrait": preload("res://assets/headshots/POWDER MONKEY FACE.png")
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
var fight = false

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
		$Textbox.visible = true
		show_cat_text(line)
			
	elif line["speaker"] == "event":
		$Button.visible = false
		$Textbox.visible = false
		fight=true
		can_play = true
		pick_crabs()
		
	elif line["speaker"] == "fadescene":
		$AnimationPlayer2.play("fade")
		await $AnimationPlayer2.animation_finished
		get_tree().change_scene_to_file("res://scene/aftercrabfight.tscn")

func _on_player_button_pressed() -> void:
	dialogue_index += 1
	show_next_dialogue()

func show_cat_text(line) -> void:
	skip_typing = false
	$Textbox.visible = true
	typing = true
	
	$Textbox/namelabel.text = line["name"]
	$Textbox/textlabel.text = line["text"]
	
	if dialogue_index == 4:
		fight = false
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

func _ready() -> void:
	$CMid.visible = false
	$CLeft.visible = false
	$CRight.visible = false
	show_next_dialogue()

func _process(delta: float) -> void:
	var crab_rect = $CMid/MidPanel.get_global_rect()
	var crab_rect2 = $CLeft/LeftPanel.get_global_rect()
	var crab_rect3 = $CRight/RightPanel.get_global_rect()
	for cannonball in get_tree().get_nodes_in_group("cannonballs"):
		var cannon_rect = cannonball.get_node("CannonPanel").get_global_rect()

		if crab_rect.intersects(cannon_rect) and C1_touchable == true and gone_1 == false:
			gone_1 = true
			cancel_crabmove = true
			await get_tree().create_timer(0.1).timeout
			var explosion = explode.instantiate()
			get_parent().add_child(explosion)
			explosion.global_position = $CMid/purplecrab.global_position
			$CMid.visible = false
		if crab_rect2.intersects(cannon_rect) and C2_touchable == true and gone_2 == false:
			gone_2 = true
			cancel_crabmove2 = true
			await get_tree().create_timer(0.1).timeout
			var explosion = explode.instantiate()
			get_parent().add_child(explosion)
			explosion.global_position = $CLeft/purplecrab.global_position
			$CLeft.visible = false
		if crab_rect3.intersects(cannon_rect) and C3_touchable == true and gone_3 == false:
			gone_3 = true
			cancel_crabmove3 = true
			await get_tree().create_timer(0.1).timeout
			var explosion = explode.instantiate()
			get_parent().add_child(explosion)
			explosion.global_position = $CRight/purplecrab.global_position
			$CRight.visible = false
	if $CMid.visible == false and $CLeft.visible == false and $CRight.visible == false:
		$CrabWalk.stop()
	if $CMid.visible == false and $CLeft.visible == false and $CRight.visible == false and playing_mg == true and spawning_crabs == false:
		playing_mg = false
		pick_crabs()

func _input(event):
	if event.is_action_pressed("ui_accept") and !typing:
		if dialogue_index < dialogue.size() and dialogue[dialogue_index]["speaker"] == "cat":
			dialogue_index += 1
			show_next_dialogue()
	elif event.is_action_pressed("ui_accept") and typing:
		skip_typing = true
		$Textbox/textlabel.visible_characters = $Textbox/textlabel.text.length()

	if event.is_action_pressed("space") and fight == true and can_shoot == true:
		can_shoot = false
		fire()
		if !is_inside_tree():
			return
		await get_tree().create_timer(0.4).timeout
		can_shoot = true
		
func fire():
	var cannonball = CannonBallScene.instantiate()
	get_parent().add_child(cannonball)

	cannonball.add_to_group("cannonballs")
	cannonball.global_position = $Cannon.global_position
	$CannonShoot.pitch_scale = 1 + randf_range(-0.1, 0.1)
	$CannonShoot.play()
	var target_z: float = cannonball.position.y - 290
	var tween: Tween = create_tween()
	tween.tween_property(cannonball, "position:y", target_z, 0.7).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)

func _physics_process(delta):
	var speed = 200.0
	var direction = Input.get_axis("left", "right")
	$Cannon.position.x += direction * speed * delta
	$Cannon.global_position.x = clamp(
		$Cannon.global_position.x,
		-267,
		267
	)


func pick_crabs():
	if spawning_crabs:
		return
		
	if rounds == 3:
		SaveManager.crab_fight = true
		can_play = false
		dialogue_index = 4
		show_next_dialogue()
		return
	
	if crab_finished == false and can_play == true:
		print(rounds)
		await get_tree().create_timer(1.5).timeout
		crab_finished = true
		$"Crabwave2-1".visible = true
		$"Crabwave1-1".visible = true
		$CMid.global_position = Vector2(223,103)
		$CLeft.global_position = Vector2(-219, 100)
		$CRight.global_position = Vector2(54,96)
		rounds += 1
		CMid = randi_range(0, 1)
		CLeft = randi_range(0, 1)
		CRight = randi_range(0, 1)
		while CMid == 0 and CLeft == 0 and CRight == 0:
			CMid = randi_range(0, 1)
			CLeft = randi_range(0, 1)
			CRight = randi_range(0, 1)
		cancel_crabmove = false
		cancel_crabmove2 = false
		cancel_crabmove3 = false
		if CMid == 1:
			gone_1 = false
			crab_move()
			$CMid.visible = true
		if CLeft == 1:
			gone_2 = false
			crab_move2()
			$CLeft.visible = true
		if CRight == 1:
			gone_3 = false
			crab_move3()
			$CRight.visible = true
		crab_finished = false
		spawning_crabs = false
		playing_mg = true

		
func crab_move3():
	if CRight == purp:
		$CRight/greencrab.visible = false
		$CRight/yellowcrab.visible = false
		var target_a: float = $CRight.position.y - 85
		var tween: Tween = create_tween()
		tween.tween_property($CRight, "position:y", target_a, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		if moving == false:
			$CrabWalk.play()
		C3_touchable = true
		if cancel_crabmove3:
			return
		$CRight/purplecrab.play("default")
		await $CRight/purplecrab.animation_finished
		if cancel_crabmove3:
			return
		$CRight/purplecrab.play("default")
		await $CRight/purplecrab.animation_finished
		var target_b: float = $CRight.position.y + 123
		var tween2: Tween = create_tween()
		tween2.tween_property($CRight, "position:y", target_b, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		$CrabWalk.stop()
		C3_touchable = false
		if cancel_crabmove3:
			return
		await get_tree().create_timer(0.6).timeout
		$"Crabwave2-1".visible = false
		var target_c: float = $CRight.position.y - 75
		var tween3: Tween = create_tween()
		tween3.tween_property($CRight, "position:y", target_c, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		if moving == false:
			$CrabWalk.play()
		C3_touchable = true
		if cancel_crabmove3:
			return
		$CRight/purplecrab.play("default")
		await $CRight/purplecrab.animation_finished
		if cancel_crabmove3:
			return
		$CRight/purplecrab.play("default")
		await $CRight/purplecrab.animation_finished
		if cancel_crabmove3:
			return
		var target_d: float = $CRight.position.y + 200
		var tween4: Tween = create_tween()
		tween4.tween_property($CRight, "position:y", target_d, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		$CrabWalk.stop()
		C3_touchable = false
		if cancel_crabmove3:
			return
		await get_tree().create_timer(0.6).timeout
		if cancel_crabmove3:
			return
		$"Crabwave1-1".visible = false
		var target_e: float = $CRight.position.y - 100
		var tween5: Tween = create_tween()
		tween5.tween_property($CRight, "position:y", target_e, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		if moving == false:
			$CrabWalk.play()
		C3_touchable = true
		if cancel_crabmove3:
			return
		$CRight/purplecrab.play("default")
		await $CRight/purplecrab.animation_finished
		if cancel_crabmove3:
			return
		$CRight/purplecrab.play("default")
		await $CRight/purplecrab.animation_finished
		var target_f: float = $CRight.position.y + 100
		var tween6: Tween = create_tween()
		tween6.tween_property($CRight, "position:y", target_f, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		$CrabWalk.stop()
		C3_touchable = false
		
	elif CRight == green:
		$CRight/yellowcrab.visible = false
		$CRight/purplecrab.visible = false
		var target_a: float = $CRight.position.y - 85
		var tween: Tween = create_tween()
		tween.tween_property($CRight, "position:y", target_a, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		if moving == false:
			$CrabWalk.play()
		C3_touchable = true
		if cancel_crabmove3:
			return
		$CRight/greencrab.play("default")
		await $CRight/greencrab.animation_finished
		if cancel_crabmove3:
			return
		$CRight/greencrab.play("default")
		await $CRight/greencrab.animation_finished
		if cancel_crabmove3:
			return
		var target_b: float = $CRight.position.y + 123
		var tween2: Tween = create_tween()
		tween2.tween_property($CRight, "position:y", target_b, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		$CrabWalk.stop()
		C3_touchable = false
		if cancel_crabmove3:
			return
		await get_tree().create_timer(0.6).timeout
		if cancel_crabmove3:
			return
		$"Crabwave2-1".visible = false
		var target_c: float = $CRight.position.y - 75
		var tween3: Tween = create_tween()
		tween3.tween_property($CRight, "position:y", target_c, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		if moving == false:
			$CrabWalk.play()
		C3_touchable = true
		if cancel_crabmove3:
			return
		$CRight/greencrab.play("default")
		await $CRight/greencrab.animation_finished
		if cancel_crabmove3:
			return
		$CRight/greencrab.play("default")
		await $CRight/greencrab.animation_finished
		if cancel_crabmove3:
			return
		var target_d: float = $CRight.position.y + 200
		var tween4: Tween = create_tween()
		tween4.tween_property($CRight, "position:y", target_d, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		$CrabWalk.stop()
		C3_touchable = false
		if cancel_crabmove3:
			return
		await get_tree().create_timer(0.6).timeout
		if cancel_crabmove3:
			return
		$"Crabwave1-1".visible = false
		var target_e: float = $CRight.position.y - 100
		var tween5: Tween = create_tween()
		tween5.tween_property($CRight, "position:y", target_e, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		if moving == false:
			$CrabWalk.play()
		C3_touchable = true
		if cancel_crabmove3:
			return
		$CRight/greencrab.play("default")
		await $CRight/greencrab.animation_finished
		if cancel_crabmove3:
			return
		$CRight/greencrab.play("default")
		await $CRight/greencrab.animation_finished
		if cancel_crabmove3:
			return
		var target_f: float = $CRight.position.y + 100
		var tween6: Tween = create_tween()
		tween6.tween_property($CRight, "position:y", target_f, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		$CrabWalk.stop()
		C3_touchable = false
		
	elif CRight == yellow:
		$CRight/greencrab.visible = false
		$CRight/purplecrab.visible = false
		
		var target_a: float = $CRight.position.y - 85
		var tween: Tween = create_tween()
		tween.tween_property($CRight, "position:y", target_a, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		if moving == false:
			$CrabWalk.play()
		C3_touchable = true
		if cancel_crabmove3:
			return
		$CRight/yellowcrab.play("default")
		await $CRight/yellowcrab.animation_finished
		if cancel_crabmove3:
			return
		$CRight/yellowcrab.play("default")
		await $CRight/yellowcrab.animation_finished
		if cancel_crabmove3:
			return
		var target_b: float = $CRight.position.y + 123
		var tween2: Tween = create_tween()
		tween2.tween_property($CRight, "position:y", target_b, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		$CrabWalk.stop()
		C3_touchable = false
		if cancel_crabmove3:
			return
		await get_tree().create_timer(0.6).timeout
		if cancel_crabmove3:
			return
		$"Crabwave2-1".visible = false
		var target_c: float = $CRight.position.y - 75
		var tween3: Tween = create_tween()
		tween3.tween_property($CRight, "position:y", target_c, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		if moving == false:
			$CrabWalk.play()
		C3_touchable = true
		if cancel_crabmove3:
			return
		$CRight/yellowcrab.play("default")
		await $CRight/yellowcrab.animation_finished
		if cancel_crabmove3:
			return
		$CRight/yellowcrab.play("default")
		await $CRight/yellowcrab.animation_finished
		var target_d: float = $CRight.position.y + 200
		var tween4: Tween = create_tween()
		tween4.tween_property($CRight, "position:y", target_d, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		$CrabWalk.stop()
		C3_touchable = false
		if cancel_crabmove3:
			return
		await get_tree().create_timer(0.6).timeout
		if cancel_crabmove3:
			return
		$"Crabwave1-1".visible = false
		var target_e: float = $CRight.position.y - 100
		var tween5: Tween = create_tween()
		tween5.tween_property($CRight, "position:y", target_e, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		if moving == false:
			$CrabWalk.play()
		C3_touchable = true
		if cancel_crabmove3:
			return
		$CRight/yellowcrab.play("default")
		await $CRight/yellowcrab.animation_finished
		if cancel_crabmove3:
			return
		$CRight/yellowcrab.play("default")
		await $CRight/yellowcrab.animation_finished
		if cancel_crabmove3:
			return
		var target_f: float = $CRight.position.y + 100
		var tween6: Tween = create_tween()
		tween6.tween_property($CRight, "position:y", target_f, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		$CrabWalk.stop()
		C3_touchable = false
	$Panel3.visible = true
	await get_tree().create_timer(0.1).timeout
	$Panel3.visible = false
	$CRight.visible = false
func crab_move2():
		# Left
	if CLeft == purp:
		$CLeft/greencrab.visible = false
		$CLeft/yellowcrab.visible = false
		var target_a: float = $CLeft.position.y - 85
		var tween: Tween = create_tween()
		tween.tween_property($CLeft, "position:y", target_a, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		if moving == false:
			$CrabWalk.play()
		C2_touchable = true
		if cancel_crabmove2:
			return
		$CLeft/purplecrab.play("default")
		await $CLeft/purplecrab.animation_finished
		if cancel_crabmove2:
			return
		$CLeft/purplecrab.play("default")
		await $CLeft/purplecrab.animation_finished
		if cancel_crabmove2:
			return
		var target_b: float = $CLeft.position.y + 123
		var tween2: Tween = create_tween()
		tween2.tween_property($CLeft, "position:y", target_b, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		$CrabWalk.stop()
		C2_touchable = false
		if cancel_crabmove2:
			return
		await get_tree().create_timer(0.6).timeout
		if cancel_crabmove2:
			return
		if cancel_crabmove2:
			return
		$"Crabwave2-1".visible = false
		var target_c: float = $CLeft.position.y - 75
		var tween3: Tween = create_tween()
		tween3.tween_property($CLeft, "position:y", target_c, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		if moving == false:
			$CrabWalk.play()
		C2_touchable = true
		if cancel_crabmove2:
			return
		$CLeft/purplecrab.play("default")
		await $CLeft/purplecrab.animation_finished
		if cancel_crabmove2:
			return
		$CLeft/purplecrab.play("default")
		await $CLeft/purplecrab.animation_finished
		if cancel_crabmove2:
			return
		var target_d: float = $CLeft.position.y + 200
		var tween4: Tween = create_tween()
		tween4.tween_property($CLeft, "position:y", target_d, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		$CrabWalk.stop()
		C2_touchable = false
		if cancel_crabmove2:
			return
		await get_tree().create_timer(0.6).timeout
		if cancel_crabmove2:
			return
		$"Crabwave1-1".visible = false
		var target_e: float = $CLeft.position.y - 100
		var tween5: Tween = create_tween()
		tween5.tween_property($CLeft, "position:y", target_e, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		if moving == false:
			$CrabWalk.play()
		C2_touchable = true
		if cancel_crabmove2:
			return
		$CLeft/purplecrab.play("default")
		await $CLeft/purplecrab.animation_finished
		if cancel_crabmove2:
			return
		$CLeft/purplecrab.play("default")
		await $CLeft/purplecrab.animation_finished
		if cancel_crabmove2:
			return
		var target_f: float = $CLeft.position.y + 100
		var tween6: Tween = create_tween()
		tween6.tween_property($CLeft, "position:y", target_f, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		$CrabWalk.stop()
		C2_touchable = false
		
	elif CLeft == green:
		$CLeft/yellowcrab.visible = false
		$CLeft/purplecrab.visible = false
		var target_a: float = $CLeft.position.y - 85
		var tween: Tween = create_tween()
		tween.tween_property($CLeft, "position:y", target_a, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		if moving == false:
			$CrabWalk.play()
		C2_touchable = true
		if cancel_crabmove2:
			return
		$CLeft/greencrab.play("default")
		await $CLeft/greencrab.animation_finished
		if cancel_crabmove2:
			return
		$CLeft/greencrab.play("default")
		await $CLeft/greencrab.animation_finished
		if cancel_crabmove2:
			return
		var target_b: float = $CLeft.position.y + 123
		var tween2: Tween = create_tween()
		tween2.tween_property($CLeft, "position:y", target_b, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		$CrabWalk.stop()
		C2_touchable = false
		if cancel_crabmove2:
			return
		await get_tree().create_timer(0.6).timeout
		if cancel_crabmove2:
			return
		$"Crabwave2-1".visible = false
		var target_c: float = $CLeft.position.y - 75
		var tween3: Tween = create_tween()
		tween3.tween_property($CLeft, "position:y", target_c, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		if moving == false:
			$CrabWalk.play()
		C2_touchable = true
		if cancel_crabmove2:
			return
		$CLeft/greencrab.play("default")
		await $CLeft/greencrab.animation_finished
		if cancel_crabmove2:
			return
		$CLeft/greencrab.play("default")
		await $CLeft/greencrab.animation_finished
		if cancel_crabmove2:
			return
		var target_d: float = $CLeft.position.y + 200
		var tween4: Tween = create_tween()
		tween4.tween_property($CLeft, "position:y", target_d, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		$CrabWalk.stop()
		C2_touchable = false
		if cancel_crabmove2:
			return
		await get_tree().create_timer(0.6).timeout
		if cancel_crabmove2:
			return
		$"Crabwave1-1".visible = false
		var target_e: float = $CLeft.position.y - 100
		var tween5: Tween = create_tween()
		tween5.tween_property($CLeft, "position:y", target_e, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		if moving == false:
			$CrabWalk.play()
		C2_touchable = true
		if cancel_crabmove2:
			return
		$CLeft/greencrab.play("default")
		await $CLeft/greencrab.animation_finished
		if cancel_crabmove2:
			return
		$CLeft/greencrab.play("default")
		await $CLeft/greencrab.animation_finished
		var target_f: float = $CLeft.position.y + 100
		var tween6: Tween = create_tween()
		tween6.tween_property($CLeft, "position:y", target_f, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		$CrabWalk.stop()
		C2_touchable = false
		
	elif CLeft == yellow:
		$CLeft/greencrab.visible = false
		$CLeft/purplecrab.visible = false
		var target_a: float = $CLeft.position.y - 85
		var tween: Tween = create_tween()
		tween.tween_property($CLeft, "position:y", target_a, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		if moving == false:
			$CrabWalk.play()
		C2_touchable = true
		if cancel_crabmove2:
			return
		$CLeft/yellowcrab.play("default")
		await $CLeft/yellowcrab.animation_finished
		if cancel_crabmove2:
			return
		$CLeft/yellowcrab.play("default")
		await $CLeft/yellowcrab.animation_finished
		if cancel_crabmove2:
			return
		var target_b: float = $CLeft.position.y + 123
		var tween2: Tween = create_tween()
		tween2.tween_property($CLeft, "position:y", target_b, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		$CrabWalk.stop()
		C2_touchable = false
		if cancel_crabmove2:
			return
		await get_tree().create_timer(0.6).timeout
		if cancel_crabmove2:
			return
		$"Crabwave2-1".visible = false
		var target_c: float = $CLeft.position.y - 75
		var tween3: Tween = create_tween()
		tween3.tween_property($CLeft, "position:y", target_c, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		if moving == false:
			$CrabWalk.play()
		C2_touchable = true
		if cancel_crabmove2:
			return
		$CLeft/yellowcrab.play("default")
		await $CLeft/yellowcrab.animation_finished
		if cancel_crabmove2:
			return
		$CLeft/yellowcrab.play("default")
		await $CLeft/yellowcrab.animation_finished
		if cancel_crabmove2:
			return
		var target_d: float = $CLeft.position.y + 200
		var tween4: Tween = create_tween()
		tween4.tween_property($CLeft, "position:y", target_d, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		$CrabWalk.stop()
		C2_touchable = false
		if cancel_crabmove2:
			return
		await get_tree().create_timer(0.6).timeout
		if cancel_crabmove2:
			return
		$"Crabwave1-1".visible = false
		var target_e: float = $CLeft.position.y - 100
		var tween5: Tween = create_tween()
		tween5.tween_property($CLeft, "position:y", target_e, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		if moving == false:
			$CrabWalk.play()
		C2_touchable = true
		if cancel_crabmove2:
			return
		$CLeft/yellowcrab.play("default")
		await $CLeft/yellowcrab.animation_finished
		if cancel_crabmove2:
			return
		var target_f: float = $CLeft.position.y + 100
		var tween6: Tween = create_tween()
		tween6.tween_property($CLeft, "position:y", target_f, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		$CrabWalk.stop()
		C2_touchable = false
	$Panel2.visible = true
	await get_tree().create_timer(0.1).timeout
	$Panel2.visible = false
	$CLeft.visible = false
	
func crab_move():
	# Middle
	if CMid == purp:
		$CMid/greencrab.visible = false
		$CMid/yellowcrab.visible = false
		var target_a: float = $CMid.position.y - 85
		var tween: Tween = create_tween()
		tween.tween_property($CMid, "position:y", target_a, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		if moving == false:
			$CrabWalk.play()
		C1_touchable = true
		if cancel_crabmove:
			return
		$CMid/purplecrab.play("default")
		await $CMid/purplecrab.animation_finished
		if cancel_crabmove:
			return
		$CMid/purplecrab.play("default")
		await $CMid/purplecrab.animation_finished
		if cancel_crabmove:
			return
		var target_b: float = $CMid.position.y + 123
		var tween2: Tween = create_tween()
		tween2.tween_property($CMid, "position:y", target_b, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		$CrabWalk.stop()
		C1_touchable = false
		if cancel_crabmove:
			return
		await get_tree().create_timer(0.6).timeout
		if cancel_crabmove:
			return
		$"Crabwave2-1".visible = false
		var target_c: float = $CMid.position.y - 75
		var tween3: Tween = create_tween()
		tween3.tween_property($CMid, "position:y", target_c, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		if moving == false:
			$CrabWalk.play()
		C1_touchable = true
		if cancel_crabmove:
			return
		$CMid/purplecrab.play("default")
		await $CMid/purplecrab.animation_finished
		if cancel_crabmove:
			return
		$CMid/purplecrab.play("default")
		await $CMid/purplecrab.animation_finished
		if cancel_crabmove:
			return
		var target_d: float = $CMid.position.y + 200
		var tween4: Tween = create_tween()
		tween4.tween_property($CMid, "position:y", target_d, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		$CrabWalk.stop()
		C1_touchable = false
		if cancel_crabmove:
			return
		await get_tree().create_timer(0.6).timeout
		if cancel_crabmove:
			return
		$"Crabwave1-1".visible = false
		var target_e: float = $CMid.position.y - 100
		var tween5: Tween = create_tween()
		tween5.tween_property($CMid, "position:y", target_e, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		if moving == false:
			$CrabWalk.play()
		C1_touchable = true
		if cancel_crabmove:
			return
		$CMid/purplecrab.play("default")
		await $CMid/purplecrab.animation_finished
		if cancel_crabmove:
			return
		$CMid/purplecrab.play("default")
		await $CMid/purplecrab.animation_finished
		if cancel_crabmove:
			return
		var target_f: float = $CMid.position.y + 50
		var tween6: Tween = create_tween()
		tween6.tween_property($CMid, "position:y", target_f, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		$CrabWalk.stop()
		C1_touchable = false
		
	elif CMid == green:
		$CMid/yellowcrab.visible = false
		$CMid/purplecrab.visible = false
		var target_a: float = $CMid.position.y - 85
		var tween: Tween = create_tween()
		tween.tween_property($CMid, "position:y", target_a, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		if moving == false:
			$CrabWalk.play()
		C1_touchable = true
		if cancel_crabmove:
			return
		$CMid/greencrab.play("default")
		await $CMid/greencrab.animation_finished
		if cancel_crabmove:
			return
		$CMid/greencrab.play("default")
		await $CMid/greencrab.animation_finished
		if cancel_crabmove:
			return
		var target_b: float = $CMid.position.y + 123
		var tween2: Tween = create_tween()
		tween2.tween_property($CMid, "position:y", target_b, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		$CrabWalk.stop()
		C1_touchable = false
		if cancel_crabmove:
			return
		await get_tree().create_timer(0.6).timeout
		if cancel_crabmove:
			return
		$"Crabwave2-1".visible = false
		var target_c: float = $CMid.position.y - 75
		var tween3: Tween = create_tween()
		tween3.tween_property($CMid, "position:y", target_c, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		if moving == false:
			$CrabWalk.play()
		C1_touchable = true
		if cancel_crabmove:
			return
		$CMid/greencrab.play("default")
		await $CMid/greencrab.animation_finished
		if cancel_crabmove:
			return
		$CMid/greencrab.play("default")
		await $CMid/greencrab.animation_finished
		if cancel_crabmove:
			return
		var target_d: float = $CMid.position.y + 200
		var tween4: Tween = create_tween()
		tween4.tween_property($CMid, "position:y", target_d, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		$CrabWalk.stop()
		C1_touchable = false
		if cancel_crabmove:
			return
		await get_tree().create_timer(0.6).timeout
		if cancel_crabmove:
			return
		$"Crabwave1-1".visible = false
		var target_e: float = $CMid.position.y - 100
		var tween5: Tween = create_tween()
		tween5.tween_property($CMid, "position:y", target_e, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		if moving == false:
			$CrabWalk.play()
		C1_touchable = true
		if cancel_crabmove:
			return
		$CMid/greencrab.play("default")
		await $CMid/greencrab.animation_finished
		if cancel_crabmove:
			return
		$CMid/greencrab.play("default")
		await $CMid/greencrab.animation_finished
		if cancel_crabmove:
			return
		var target_f: float = $CMid.position.y + 50
		var tween6: Tween = create_tween()
		tween6.tween_property($CMid, "position:y", target_f, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		$CrabWalk.stop()
		C1_touchable = false
	
	elif CMid == yellow:
		$CMid/greencrab.visible = false
		$CMid/purplecrab.visible = false
		var target_a: float = $CMid.position.y - 85
		var tween: Tween = create_tween()
		tween.tween_property($CMid, "position:y", target_a, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		if moving == false:
			$CrabWalk.play()
		C1_touchable = true
		if cancel_crabmove:
			return
		$CMid/yellowcrab.play("default")
		await $CMid/yellowcrab.animation_finished
		if cancel_crabmove:
			return
		$CMid/yellowcrab.play("default")
		await $CMid/yellowcrab.animation_finished
		if cancel_crabmove:
			return
		var target_b: float = $CMid.position.y + 123
		var tween2: Tween = create_tween()
		tween2.tween_property($CMid, "position:y", target_b, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		$CrabWalk.stop()
		C1_touchable = false
		if cancel_crabmove:
			return
		await get_tree().create_timer(0.6).timeout
		if cancel_crabmove:
			return
		$"Crabwave2-1".visible = false
		var target_c: float = $CMid.position.y - 75
		var tween3: Tween = create_tween()
		tween3.tween_property($CMid, "position:y", target_c, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		if moving == false:
			$CrabWalk.play()
		C1_touchable = true
		if cancel_crabmove:
			return
		$CMid/yellowcrab.play("default")
		await $CMid/yellowcrab.animation_finished
		if cancel_crabmove:
			return
		$CMid/yellowcrab.play("default")
		await $CMid/yellowcrab.animation_finished
		if cancel_crabmove:
			return
		var target_d: float = $CMid.position.y + 200
		var tween4: Tween = create_tween()
		tween4.tween_property($CMid, "position:y", target_d, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		$CrabWalk.stop()
		C1_touchable = false
		if cancel_crabmove:
			return
		await get_tree().create_timer(0.6).timeout
		if cancel_crabmove:
			return
		$"Crabwave1-1".visible = false
		var target_e: float = $CMid.position.y - 100
		var tween5: Tween = create_tween()
		tween5.tween_property($CMid, "position:y", target_e, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		if moving == false:
			$CrabWalk.play()
		C1_touchable = true
		if cancel_crabmove:
			return
		$CMid/yellowcrab.play("default")
		await $CMid/yellowcrab.animation_finished
		if cancel_crabmove:
			return
		$CMid/yellowcrab.play("default")
		await $CMid/yellowcrab.animation_finished
		if cancel_crabmove:
			return
		var target_f: float = $CMid.position.y + 50
		var tween6: Tween = create_tween()
		tween6.tween_property($CMid, "position:y", target_f, 0.3).set_trans(Tween.TRANS_QUAD).set_ease(Tween.EASE_OUT)
		$CrabWalk.stop()
		C1_touchable = false
	$Panel.visible = true
	await get_tree().create_timer(0.1).timeout
	$Panel.visible = false
	$CMid.visible = false
