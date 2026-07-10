extends Area3D

@export var speed = 1
var is_launch: bool = false

func launch():
	is_launch = true

func _physics_process(_delta: float) -> void:
	if is_launch:
		global_position += global_transform.basis.y*speed
