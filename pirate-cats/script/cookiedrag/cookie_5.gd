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
		dragging = false
		if $Panel2.get_global_rect().intersects($"../../Panel".get_global_rect()):
			if $"../..".eating == false:
				can_drag = false
				$".".visible = false
				$"../..".parrot_eat()
			else:
				$".".global_position = Vector2(-132, 111)

func _on_button_button_down() -> void:
	if can_drag:
		dragging = true
	of = get_global_mouse_position() - global_position
	
