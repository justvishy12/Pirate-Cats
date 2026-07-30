extends Node2D


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass


func _on_continue_pressed() -> void:
	SaveManager.save_game(SaveManager.current_slot)
	Global.paused = false
	$".".visible = false
	get_tree().paused = false


func _on_home_pressed() -> void:
	Global.paused = false
	SaveManager.save_game(SaveManager.current_slot)
	get_tree().paused = false
	get_tree().change_scene_to_file("res://scene/loading.tscn")
