extends Node2D

func _ready() -> void:
	SaveManager.current_slot = 0
	refresh_slots()

func refresh_slots():
	for i in range(1, 4):
		var slot = get_node("Loading/Save%d" % i)

		var thumbnail = SaveManager.load_thumbnail(i)

		if thumbnail:
			slot.get_node("Thumbnail").texture = thumbnail
		else:
			slot.get_node("Thumbnail").texture = load("res://assets/txture plc holder.png")

		var data = SaveManager.get_save_data(i)

		if data:
			var datetime = data["saved_at"].split("T")

			var date = datetime[0].split("-")
			var time = datetime[1].substr(0, 5)

			slot.get_node("Container/Date").text = "%s/%s/%s" % [date[2], date[1], date[0]]
			slot.get_node("Container/Time").text = time

func _process(delta: float) -> void:
	if $Guide.visible == true or $Prefferences.visible == true or $credits.visible == true:
		$GuideInstructiosn.visible = false
	else:
		$GuideInstructiosn.visible = true
func _on_load_1_pressed() -> void:
	SaveManager.current_slot = 1
	if SaveManager.crab_fight == false:
		get_tree().change_scene_to_file("res://scene/ship_sailing.tscn")
	else:
		get_tree().change_scene_to_file("res://scene/Backship.tscn")

func _on_load_2_pressed() -> void:
	SaveManager.current_slot = 2
	if SaveManager.crab_fight == false:
		get_tree().change_scene_to_file("res://scene/ship_sailing.tscn")
	else:
		get_tree().change_scene_to_file("res://scene/Backship.tscn")

func _on_load_3_pressed() -> void:
	SaveManager.current_slot = 3
	if SaveManager.crab_fight == false:
		get_tree().change_scene_to_file("res://scene/ship_sailing.tscn")
	else:
		get_tree().change_scene_to_file("res://scene/Backship.tscn")

func _on_reset_1_pressed() -> void:
	SaveManager.delete_save(1)
	refresh_slots()
	$Loading/Save1/Thumbnail.texture = load("res://assets/txture plc holder.png")
	$Loading/Save1/Container/Date.text = "xx/xx/xxxx"
	$Loading/Save1/Container/Time.text = "xx:xx"


func _on_reset_2_pressed() -> void:
	SaveManager.delete_save(2)
	refresh_slots()
	$Loading/Save2/Thumbnail.texture = load("res://assets/txture plc holder.png")
	$Loading/Save2/Container/Date.text = "xx/xx/xxxx"
	$Loading/Save2/Container/Time.text = "xx:xx"

func _on_reset_3_pressed() -> void:
	SaveManager.delete_save(3)
	refresh_slots()
	$Loading/Save3/Thumbnail.texture = load("res://assets/txture plc holder.png")
	$Loading/Save3/Container/Date.text = "xx/xx/xxxx"
	$Loading/Save3/Container/Time.text = "xx:xx"


func _on_guide_pressed() -> void:
	$Guide.visible = true
	$Arrows.visible=true
	$Area2D.visible=true



func _on_prefferences_pressed() -> void:
	$Prefferences.visible = true
	$Arrows.visible=true
	$Area2D.visible=true


func _on_creds_pressed() -> void:
	$credits.visible=true
	$Arrows.visible=true
	$Area2D.visible=true


func _on_area_2d_pressed() -> void:
		print("hii")
		$Guide.visible=false
		$Prefferences.visible=false
		$credits.visible=false
		$Arrows.visible=false
		$Area2D.visible=false
