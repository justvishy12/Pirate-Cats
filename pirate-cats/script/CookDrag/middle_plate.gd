extends Sprite2D
var dragging = false
var of = Vector2(0,0)
var can_drag = true
var in_zone = false

func _process(delta: float) -> void:
	if dragging:
		global_position = get_global_mouse_position() - of
	


func _on_button_button_up() -> void:
	if can_drag:
		$".".self_modulate = Color(1.0, 1.0, 1.0)
		dragging = false
		if $Panel.get_global_rect().intersects(get_parent().get_node("PlatePanel").get_global_rect()):
			$"..".plate += 1
			print("Plate =", $"..".plate)
			in_zone = true
			can_drag = false
			$".".global_position = Vector2(298, 540)
		else:
			$".".self_modulate = Color(1.0, 1.0, 1.0, 0.0)
			$".".global_position = Vector2(86,491)

func _on_button_button_down() -> void:
	$".".self_modulate= Color(1.0, 1.0, 1.0)
	if can_drag:
		dragging = true
		of = get_global_mouse_position() - global_position
	
