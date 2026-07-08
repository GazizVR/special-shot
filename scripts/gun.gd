extends Node3D

@onready var bullet = $Bullet
@export var strength = 2

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("shot"):
		var copy = bullet.duplicate()
		add_child(copy)
		copy.launch()
