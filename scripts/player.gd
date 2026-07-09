extends CharacterBody3D

@export var mouseSensetivity = 0.001

func to_hand(node: Node3D) -> void:
	$CamPivot/Hand.add_child(node)

func _enter_tree() -> void:
	set_multiplayer_authority(name.to_int())
	$CamPivot/Camera.current = is_multiplayer_authority()

func _input(event: InputEvent) -> void:
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
@export var gravity = 100
var target_velocity = Vector3.ZERO
var is_crouch = false
@export var crouch_per = 0.6

func _physics_process(delta: float) -> void:
	if !is_multiplayer_authority(): return
	var direction = Vector3.ZERO
	if not is_on_floor():
		if global_position.y < 0.5:
			global_position = Vector3(0,2,0)
			return
		direction.y -= gravity * delta
		target_velocity.y = direction.y
	else:
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
