extends Node2D
var rotations = 0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	rotations = randi_range(0, 360)
	$Explosion.rotation = rotations
	$AnimationPlayer.play("explode")


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
