extends Node2D
var rightcam = false
var leftcam = false
var paused = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


func _input(event):
	if event.is_action_pressed("escape"):
		print("works")
		if paused == false:
			
			toggle_pause()

func toggle_pause():
	var pause_menu = get_tree().current_scene.find_child("pausemenu", true, false)
	if pause_menu:
		prints("pauise")
		paused = true
		get_tree().paused = true
		pause_menu.visible = true
