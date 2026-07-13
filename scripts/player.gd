extends CharacterBody3D

var is_paused = false
@export var team: GameManager.Team = GameManager.selected_team

func return_to_menu():
	if get_tree() != null:
		multiplayer.multiplayer_peer.close()
		get_tree().change_scene_to_file("res://scenes/menu.tscn")
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE

@export var player_color = Color("#654321"):
	set(value):
		player_color = value
		if not is_inside_tree():
			await ready
		$Model/Suzanne.material_override.albedo_color = value
		$Model/Cylinder.material_override.albedo_color = value
		$Model/Sphere.material_override.albedo_color = value

var spawn_point: Vector3 = Vector3.ZERO

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
	$CamPivot/Camera.current = is_multiplayer_authority()
	
func _ready() -> void:
	match team:
		GameManager.Team.ZERO:
			spawn_point = GameManager.zero_team_spawn
			global_position = spawn_point
			player_color = Color.RED
		GameManager.Team.UNIT:
			spawn_point = GameManager.unit_team_spawn
			global_position = spawn_point
			player_color = Color.BLUE
		_:
			global_position = spawn_point
	var look_basis = Vector3(spawn_point.x,0,spawn_point.z)
	basis = Basis.looking_at(look_basis)

func _input(event: InputEvent) -> void:
	if is_paused: return
	if !is_multiplayer_authority(): return
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x*GameManager.camera_sensitivity)
		var vertical_rotaion = event.relative.y*GameManager.camera_sensitivity
		$CamPivot.rotation.x = clamp(
			$CamPivot.rotation.x+vertical_rotaion,
			deg_to_rad(-75),
			deg_to_rad(90)
		)
		
@export var speed = 8
@export var gravity = 10
var target_velocity = Vector3.ZERO
var is_crouch = false
@export var health = 100

func _process(delta: float) -> void:
	if is_paused: return
	if !is_multiplayer_authority(): return
	$CanvasLayer/Control/HPLabel.text = "HP " + str(health)

@rpc("authority","call_local","reliable")
func zero_health():
	if team == GameManager.Team.ZERO:
		GameManager.unit_team_score += 1
	if team == GameManager.Team.UNIT:
		GameManager.zero_team_score += 1

func _physics_process(delta: float) -> void:
	if !is_multiplayer_authority(): return
	if health < 1:
		zero_health.rpc()
		velocity = Vector3.ZERO
		global_position = spawn_point
		health = 100
		move_and_slide()
	if not is_on_floor():
		if global_position.y < -2:
			health = 0
			return
		target_velocity.y -= gravity * delta
		velocity = target_velocity
		move_and_slide()
	if is_paused: return
	var direction = Vector3.ZERO
	if is_on_floor():
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
	if direction != Vector3.ZERO:
		velocity = target_velocity
		move_and_slide()
		
var frag_count = 0

@rpc("authority","call_local","reliable")
func _on_gun_bullet_touched(bullet: Area3D, body: Node3D) -> void:
	$CamPivot/Hand/Gun.call_deferred("remove_child",bullet)
	var peer_id = body.name
	var peer_node_path = "/root/Game/" + peer_id
	var peer_node = get_node(peer_node_path)
	if is_instance_valid(peer_node):
		if "health" in peer_node:
			var has_team: bool = [peer_node,bullet.shooter].all(func(node): return "team" in node)
			if has_team:
				if peer_node.team != bullet.shooter.team:
					peer_node.health -= 20

func _notification(what: int) -> void:
	if what == NOTIFICATION_PAUSED:
		velocity = Vector3.ZERO
		is_paused = true
	if what == NOTIFICATION_UNPAUSED:
		is_paused = false
