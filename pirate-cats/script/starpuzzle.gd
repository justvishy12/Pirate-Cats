extends Node2D
var leftside = false
var rightside = false
var round1 = false
var round2 = false
var round3 = false
var r1d = false
var r2d = false
var r3d = false
var roundS = false
var p1 = false
var p2 = false
var p3 = false
var round1done = false
var round2done = false
var round3done = false
var side_movement = 0
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	round_finished()



func round_finished():
	await get_tree().create_timer(0.4).timeout
	if round1 == false:
		roundS = true
		$AnimationPlayer.play("ButtonIn")
	elif round1 == true and round2 == false:
		roundS = true
		$Timer.stop()
		$AnimationPlayer.play("ButtonIn")
	elif round2 == true and round3 == false:
		roundS = true
		$Timer.stop()
		$AnimationPlayer.play("ButtonIn")
# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if side_movement == 1 and  roundS == false:
		$Wheel.rotation += -1.0 * delta
	if side_movement == 2 and roundS == false:
		$Wheel.rotation += 1.0 * delta
	
#region Setup
	if roundS == true:
		side_movement = 0
		if round1 == false:
			$PawprintConstellation.global_position.x = 199
			$ShirtConstellation.global_position.x = 934
			$PawprintConstellation.modulate.a = min(1.0, $PawprintConstellation.modulate.a + delta)
			$ShirtConstellation.modulate.a = min(1.0, $ShirtConstellation.modulate.a + delta)

			if $PawprintConstellation.modulate.a >= 1.0 and $ShirtConstellation.modulate.a >= 1.0:
				roundS = false
				
		elif round2 == false:
			$BootConstellation.global_position.x = 182
			$CatFaceConstellation.global_position.x = 942
			$BootConstellation.modulate.a = min(1.0, $BootConstellation.modulate.a + delta)
			$CatFaceConstellation.modulate.a = min(1.0, $CatFaceConstellation.modulate.a + delta)

			if $BootConstellation.modulate.a >= 1.0 and $CatFaceConstellation.modulate.a >= 1.0:
				roundS = false
				
		elif round3 == false:
			$FishConstellation.global_position.x = 197
			$PantsConstellation.global_position.x = 944
			$FishConstellation.modulate.a = min(1.0, $FishConstellation.modulate.a + delta)
			$PantsConstellation.modulate.a = min(1.0, $PantsConstellation.modulate.a + delta)

			if $PantsConstellation.modulate.a >= 1.0 and $PantsConstellation.modulate.a >= 1.0:
				roundS = false
#endregion
	
	
	
#region Fading DOne
		
	if $PawprintConstellation.global_position.x >= 575:
		$PawprintConstellation.modulate.a = max(0.0, $PawprintConstellation.modulate.a - delta)
		if $PawprintConstellation.modulate.a <= 0.0 and p1 == false:
			round1done = true
			$Wheel.rotation += -2.0 * delta
			p1 = true
			round1 = true
			round_finished()
		
	if $ShirtConstellation.global_position.x <= 575:
		$ShirtConstellation.modulate.a = max(0.0, $ShirtConstellation.modulate.a - delta)
		if $ShirtConstellation.modulate.a <= 0.0 and p1 == false:
			round1done = true
			$Wheel.rotation += 2.0 * delta
			p1 = true
			round1 = false
			round_finished()
		

		
	if $BootConstellation.global_position.x >= 575:
		$BootConstellation.modulate.a = max(0.0,  $BootConstellation.modulate.a - delta)
		if $BootConstellation.modulate.a <= 0.0 and p2== false:
			round2done = true
			$Wheel.rotation += -2.0 * delta
			p2 = true
			round2 = false
			round_finished()

	if $CatFaceConstellation.global_position.x <= 575:
		$CatFaceConstellation.modulate.a = max(0.0, $CatFaceConstellation.modulate.a - delta)
		if $CatFaceConstellation.modulate.a <= 0.0 and p2 == false:
			round2done = true
			$Wheel.rotation += 2.0 * delta
			p2 = true
			round2 = true
			round_finished()

	if $FishConstellation.global_position.x >= 575:
		$FishConstellation.modulate.a = max(0.0,  $FishConstellation.modulate.a - delta)
		if $FishConstellation.modulate.a <= 0.0 and p3 == false:
			round3done = true
			$Wheel.rotation += -2.0 * delta
			p3 = true
			round3 = true
			round_finished()

	if $PantsConstellation.global_position.x <= 575:
		$PantsConstellation.modulate.a = max(0.0, $PantsConstellation.modulate.a - delta)
		if $PantsConstellation.modulate.a <= 0.0 and p3 == false:
			round3done = true
			$Wheel.rotation += 2.0 * delta
			p3 = true
			round3 = false
			round_finished()
#endregion

		
		
#region Movement
	if round1 == true and round2 == false  and round1done == false:
		print( $PawprintConstellation.global_position.x)
		if side_movement == 1 and $PawprintConstellation.global_position.x <= 575:
			$PawprintConstellation.global_position += Vector2(150, 0) * delta
			$ShirtConstellation.global_position += Vector2(150, 0) * delta

		elif side_movement == 2 and $ShirtConstellation.global_position.x >= 575:
			print( $ShirtConstellation.global_position.x)
			$ShirtConstellation.global_position += Vector2(-150, 0) * delta
			$PawprintConstellation.global_position += Vector2(-150, 0) * delta

				
				
	if round2 == true and round3 == false  and round2done == false:
		if side_movement == 1 and $BootConstellation.global_position.x <= 575:
			$BootConstellation.global_position += Vector2(150, 0) * delta
			$CatFaceConstellation.global_position += Vector2(150, 0) * delta

		elif  side_movement == 2 and $CatFaceConstellation.global_position.x >= 575:
			$CatFaceConstellation.global_position += Vector2(-150, 0) * delta
			$BootConstellation.global_position += Vector2(-150, 0) * delta
		
				
	if round3 == true and round3done == false:
		if side_movement == 1 and $FishConstellation.global_position.x <= 575:
			$FishConstellation.global_position += Vector2(150, 0) * delta
			$PantsConstellation.global_position += Vector2(150, 0) * delta

		elif side_movement == 2 and $PantsConstellation.global_position.x >= 575:
			$PantsConstellation.global_position += Vector2(-150, 0) * delta
			$FishConstellation.global_position += Vector2(-150, 0) * delta
#endregion



#region Left and Right
func _on_left_side_mouse_entered() -> void:
	leftside = true
	$Timer.start()



func _on_left_side_mouse_exited() -> void:
	leftside = false
	$Timer.stop()

func _on_right_side_mouse_entered() -> void:
	rightside = true
	$Timer.start()

func _on_right_side_mouse_exited() -> void:
	rightside = false
	$Timer.stop()
#endregion



func _on_timer_timeout() -> void:
	$Timer.stop()
	if round1 == false:
		if leftside:
			side_movement = 1
		elif rightside:
			side_movement = 2
		leftside = false
		rightside = false
		round1 = true
		p1 = false
	elif round2 == false:
		if leftside:
			side_movement = 1
		elif rightside:
			side_movement = 2
		leftside = false
		rightside = false
		round2 = true
		p2 = false
	elif round3 == false:
		if leftside:
			side_movement = 1
		elif rightside:
			side_movement = 2
		leftside = false
		rightside = false
		round3 = true
		p3 = false
		
