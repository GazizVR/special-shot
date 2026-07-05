extends CharacterBody3D

@export var mouseSensetivity = 0.001

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x*mouseSensetivity)
		$Camera.rotate_x(event.relative.y*mouseSensetivity)
