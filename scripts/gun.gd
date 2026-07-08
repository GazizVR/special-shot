extends Node3D

@onready var bullet = $Bullet
@export var strength = 2
var can_shot = true

func _physics_process(delta: float) -> void:
	if Input.is_action_just_pressed("shot") and can_shot:
		shot()
func shot():
	can_shot = false
	var copy = bullet.duplicate()
	add_child(copy)
	copy.top_level = true
	copy.visible = true
	copy.launch()
	await get_tree().create_timer(0.5).timeout
	can_shot = true
