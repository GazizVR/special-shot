extends CharacterBody3D

@export var mouseSensetivity = 0.001

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x*mouseSensetivity)
		$Camera.rotation.x += event.relative.y*mouseSensetivity
		$Camera.rotation.x = clamp(
			$Camera.rotation.x,
			deg_to_rad(-60),
			deg_to_rad(60)
		)
