extends CharacterBody3D

@export var mouseSensetivity = 0.001

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x*mouseSensetivity)
		var vertical_rotaion = event.relative.y*mouseSensetivity
		$Hand.rotation.x = clamp(
			$Hand.rotation.x+vertical_rotaion,
			deg_to_rad(-60),
			deg_to_rad(60)
		)
		$Camera.rotation.x = clamp(
			$Camera.rotation.x-vertical_rotaion,
			deg_to_rad(-60),
			deg_to_rad(60)
		)
		
@export var speed = 8
@export var gravity = 100
var target_velocity = Vector3.ZERO

func _physics_process(delta: float) -> void:
	var direction = Vector3.ZERO
	if not is_on_floor():
		if global_position.y < 0.5:
			global_position = Vector3(0,1,0)
			return
		direction.y -= gravity * delta
		target_velocity.y = direction.y
	else:
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
