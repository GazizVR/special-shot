extends Node3D

func _ready() -> void:
	var gun_scene = preload("res://scenes/Gun.tscn")
	var gun_node = gun_scene.instantiate()
	$Player/Hand.add_child(gun_node)
