extends CharacterBody3D

@export var mouseSensetivity = 0.001

func _input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		rotate_y(-event.relative.x*mouseSensetivity)
		$Camera.rotation.x = clamp(
			$Camera.rotation.x-event.relative.y*mouseSensetivity,
			deg_to_rad(-60),
			deg_to_rad(60)
		)
		
@export var speed = 8
var target_velocity = Vector3.ZERO

func _physics_process(delta: float) -> void:
	var direction = Vector3.ZERO
	if Input.is_action_pressed("walk_forward"):
		direction += global_transform.basis.z
	if Input.is_action_pressed("walk_back"):
		direction -= global_transform.basis.z
	if Input.is_action_pressed("walk_right"):
		direction -= global_transform.basis.x
	if Input.is_action_pressed("walk_left"):
		direction += global_transform.basis.x
	target_velocity.x = direction.x * speed
	target_velocity.z = direction.z * speed
	velocity = target_velocity
	move_and_slide()
