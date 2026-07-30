extends Node2D
var clicks = 0
var treasure = false
var shells = false
var coconuts = false
var cones = false
var stars
var find = false
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass




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
			get_parent().tres()	
			$CandiedCatnip.visible = true
