extends Node3D

signal bullet_touched(bullet: Area3D,body: Node3D)

@onready var bullet = $Bullet
var can_shot = true
var is_paused = false

func _physics_process(_delta: float) -> void:
	if is_paused: return
	if !is_multiplayer_authority(): return
	if Input.is_action_just_pressed("shot") and can_shot:
		shot.rpc()

@rpc("authority","call_local","reliable")
func shot():
	can_shot = false
	var copy = bullet.duplicate()
	copy.body_entered.connect(on_entered(copy))
	add_child(copy)
	copy.visible = true
	copy.top_level = true
	copy.launch()
	await get_tree().create_timer(0.5).timeout
	can_shot = true

func on_entered(bullet: Area3D) -> Callable:
	return func(body: Node3D):
		bullet_touched.emit(bullet,body)

func _notification(what: int) -> void:
	if what == NOTIFICATION_PAUSED:
		is_paused = true
	if what == NOTIFICATION_UNPAUSED:
		is_paused = false
