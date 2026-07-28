extends Node

const SAVE_FOLDER = "user://"
var current_slot = 0
var scene = 1
var coins = 0
var fish_played = false
var cook_played = false
var fishmap = false
var cookmap = false
var crabmap = false
var parrotmap = false
var captainmap = false
var powdermap = false
var fish = false
var cook = false
var scrub = false
var feed = false
var sort = false

func save_game(slot: int) -> void:
	var path = SAVE_FOLDER + "save_%d.json" % slot

	var data = {
		"saved_at": Time.get_datetime_string_from_system(),
		"scene": scene
	}

	var file = FileAccess.open(path, FileAccess.WRITE)
	file.store_string(JSON.stringify(data))
	file.close()

	await RenderingServer.frame_post_draw
	save_screenshot(slot)
	
func delete_save(slot: int):
	var save_path = SAVE_FOLDER + "save_%d.json" % slot
	var screenshot_path = "user://save_%d.png" % slot

	if FileAccess.file_exists(save_path):
		DirAccess.remove_absolute(save_path)
		print("Deleted save:", slot)

	if FileAccess.file_exists(screenshot_path):
		DirAccess.remove_absolute(screenshot_path)
		print("Deleted screenshot:", slot)
func _on_close_requested():
	if current_slot != 0:
		print("Saving because of quit")
		await save_game(current_slot)

	get_tree().quit()


func load_game(slot: int):
	var path = SAVE_FOLDER + "save_%d.json" % slot

	if not FileAccess.file_exists(path):
		return null

	var file = FileAccess.open(path, FileAccess.READ)
	var data = JSON.parse_string(file.get_as_text())
	file.close()

	if data == null:
		return null

	scene = int(data.get("scene", 1))

	return data

func get_save_data(slot: int):
	var path = SAVE_FOLDER + "save_%d.json" % slot

	if !FileAccess.file_exists(path):
		return null

	var file = FileAccess.open(path, FileAccess.READ)
	var text = file.get_as_text()
	file.close()
	print(text)

	return JSON.parse_string(text)

func save_screenshot(slot: int):
	var image = get_viewport().get_texture().get_image()

	var path = "user://save_%d.png" % slot
	image.save_png(path)
	print("Screenshot saved:", path)
func load_thumbnail(slot: int) -> Texture2D:
	var path = "user://save_%d.png" % slot

	if not FileAccess.file_exists(path):
		return null

	var image = Image.load_from_file(path)
	return ImageTexture.create_from_image(image)
 
