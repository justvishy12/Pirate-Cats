extends Node2D
var clicks = 0
var treasure = false
var shells = false
var coconuts = false
var cones = false
var stars
var find = false

func _process(delta: float) -> void:
	if get_parent().treasure == true:
		$Button.disabled = true
		$Button.global_position =Vector2(8000,8000)

func _on_button_pressed() -> void:
	clicks += 1
	if clicks == 1:
		$Dig.play()
		$Hole.visible = true
		$MidSandPile.visible = true
	elif clicks == 2:
		$Dig.play()
		$DeepHole.visible = true
		$Sandpile.visible = true
		if treasure == false:
			if treasure == true:
				get_parent().treasure()
			elif shells == true:
				get_parent().shells()
			elif coconuts == true:
				get_parent().coconuts()
			elif cones == true:
				get_parent().cones()
			elif  stars == true:
				get_parent().stars()
			elif  find == true:
				get_parent().find()
		if treasure == true:
			$Button.disabled = true
			get_parent().tres()	
			$CandiedCatnip.visible = true
