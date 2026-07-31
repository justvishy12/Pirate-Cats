extends HSlider


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	value = SaveManager.speed

func _process(delta: float) -> void:
	SaveManager.speed = -value
