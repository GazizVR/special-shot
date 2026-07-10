extends Node3D

@onready var bullet = $Bullet
var can_shot = true

func _physics_process(_delta: float) -> void:
	if !is_multiplayer_authority(): return
	if Input.is_action_just_pressed("shot") and can_shot:
		shot.rpc()

@rpc("authority","call_local","reliable")
func shot():
	can_shot = false
	var copy = bullet.duplicate()
	add_child(copy)
	copy.visible = true
	copy.top_level = true
	copy.launch()
	await get_tree().create_timer(0.5).timeout
	can_shot = true
