extends Node3D

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("shot"):
		print("shot!")
