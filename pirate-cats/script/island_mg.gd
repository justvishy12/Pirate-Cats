extends Node2D
var mos_pos 
var shovel = preload("res://assets/shovel cursor.png")
var one = false
var two = false
var three =false
var four = false
var five = false
var six = false
var sand_scene = preload("res://scene/sand.tscn")
var treas = randi_range(1, 6)
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	#Input.set_custom_mouse_cursor(shovel)
	pass
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func shells():
	print("its not near the shells")
func coconuts():
	print("its not near the coconuts")
func cones():
	print("its not near the coconuts")
func find():
	print("maybe we should move away")
func treasure():
	print("lets keep digging")


func tres():
	$Button.disabled = true
	$Button2.disabled = true
	$Button3.disabled = true
	$Button4.disabled = true
	$Button5.disabled = true
	$Button6.disabled = true
	print("Yay, you found our treassure, we must repay you and take you home!")
func _on_side_pressed() -> void:
	print("too far out")


func _on_side_2_pressed() -> void:
	print("too far out")


func _on_top_pressed() -> void:
	print("too far out")


func _on_bottom_pressed() -> void:
	print("too far out")


func _on_button_pressed() -> void:
	mos_pos = get_global_mouse_position()
	var sand = sand_scene.instantiate()
	sand.global_position = mos_pos
	add_child(sand)
	sand.coconuts = true
	if treas == 1:
		sand.treasure = true


func _on_button_2_pressed() -> void:
	mos_pos = get_global_mouse_position()
	var sand = sand_scene.instantiate()
	sand.global_position = mos_pos
	add_child(sand)
	if treas == 2:
		sand.treasure = true



func _on_button_3_pressed() -> void:
	mos_pos = get_global_mouse_position()
	var sand = sand_scene.instantiate()
	sand.global_position = mos_pos
	add_child(sand)
	if treas == 3:
		sand.treasure = true



func _on_button_4_pressed() -> void:
	mos_pos = get_global_mouse_position()
	var sand = sand_scene.instantiate()
	sand.global_position = mos_pos
	add_child(sand)
	if treas == 4:
		sand.treasure = true



func _on_button_5_pressed() -> void:
	mos_pos = get_global_mouse_position()
	var sand = sand_scene.instantiate()
	sand.global_position = mos_pos
	sand.cones = true
	add_child(sand)
	if treas == 5:
		sand.treasure = true



func _on_button_6_pressed() -> void:
	mos_pos = get_global_mouse_position()
	var sand = sand_scene.instantiate()
	sand.global_position = mos_pos
	sand.shells = true
	add_child(sand)
	if treas == 6:
		sand.treasure = true
