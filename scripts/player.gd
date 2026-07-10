extends CharacterBody3D

@export var mouseSensetivity = 0.001
var is_paused = false

func return_to_menu():
	if get_tree() != null:
		multiplayer.multiplayer_peer.close()
		get_tree().change_scene_to_file("res://scenes/Menu.tscn")

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
	$CamPivot/Camera.current = is_multiplayer_authority()

func _input(event: InputEvent) -> void:
	if is_paused: return
	if !is_multiplayer_authority(): return
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x*mouseSensetivity)
		var vertical_rotaion = event.relative.y*mouseSensetivity
		$CamPivot.rotation.x = clamp(
			$CamPivot.rotation.x+vertical_rotaion,
			deg_to_rad(-60),
			deg_to_rad(90)
		)
		
@export var speed = 8
@export var gravity = 10
var target_velocity = Vector3.ZERO
var is_crouch = false
@export var crouch_per = 0.6
@export var health = 100

func _process(delta: float) -> void:
	if is_paused: return
	if !is_multiplayer_authority(): return
	$CanvasLayer/Control/HPLabel.text = "HP " + str(health)

func _physics_process(delta: float) -> void:
	if !is_multiplayer_authority(): return
	if health < 1:
		velocity = Vector3(0,0,0)
		global_position = Vector3(0,3,0)
		health = 100
	if not is_on_floor():
		if global_position.y < -2:
			health = 0
			return
		target_velocity.y -= gravity * delta
		velocity.y = target_velocity.y
	if is_paused:
		move_and_slide()
		return	
	var direction = Vector3.ZERO
	if is_on_floor():
		if Input.is_action_just_pressed("crouch"):
			is_crouch = !is_crouch
			if is_crouch:
				$Body.scale.y *= crouch_per
				$Model.scale.y *= crouch_per
				$CamPivot.position.y *= crouch_per
				speed *= crouch_per
			else:
				$Body.scale.y /= crouch_per
				$Model.scale.y /= crouch_per
				$CamPivot.position.y /= crouch_per
				speed /= crouch_per
		if Input.is_action_pressed("walk_forward"):
			direction += global_transform.basis.z
		if Input.is_action_pressed("walk_back"):
			direction -= global_transform.basis.z
		if Input.is_action_pressed("walk_right"):
			direction -= global_transform.basis.x
		if Input.is_action_pressed("walk_left"):
			direction += global_transform.basis.x
		if direction != Vector3.ZERO:
			direction = direction.normalized()
		target_velocity.x = direction.x * speed
		target_velocity.z = direction.z * speed
	velocity = target_velocity
	move_and_slide()

@rpc("authority","call_local","reliable")
func _on_gun_bullet_touched(bullet: Area3D, body: Node3D) -> void:
	$CamPivot/Hand/Gun.remove_child(bullet)
	var peer_id = body.name
	var peer_node_path = "/root/game/" + peer_id
	var peer_node = get_node(peer_node_path)
	if is_instance_valid(peer_node):
		if peer_node is CharacterBody3D:
			peer_node.health -= 20

func _notification(what: int) -> void:
	if what == NOTIFICATION_PAUSED:
		is_paused = true
	if what == NOTIFICATION_UNPAUSED:
		is_paused = false
