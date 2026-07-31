extends Node2D
var rightcam = false
var leftcam = false
var paused = false
var in_ship = false

var music_player: AudioStreamPlayer

var music_scenes = [
	"res://scene/SideShipView1.tscn",
	"res://scene/SideShipView2.tscn",
	"res://scene/FrontShip.tscn",
	"res://scene/Backship.tscn",
	"res://scene/Captain Room.tscn",
	"res://scene/ship_sailing.tscn"
]

func _ready():
	music_player = AudioStreamPlayer.new()
	add_child(music_player)

	music_player.stream = load("res://audio/ShipMovement.mp3")
	music_player.bus = "Music"
	music_player.volume_db = -20

	await get_tree().process_frame
	check_scene()

func _process(delta: float) -> void:
	check_scene()
func check_scene():
	
	while get_tree().current_scene == null:
		await get_tree().process_frame

	var scene = get_tree().current_scene
	if scene.scene_file_path in music_scenes and !music_player.playing:
		music_player.play()
	elif scene.scene_file_path not in music_scenes:
		music_player.stop()
			
func _input(event):
	if event.is_action_pressed("escape"):
		if paused == false:
			
			toggle_pause()

func toggle_pause():
	var pause_menu = get_tree().current_scene.find_child("pausemenu", true, false)
	if pause_menu:
		prints("pauise")
		paused = true
		get_tree().paused = true
		pause_menu.visible = true
