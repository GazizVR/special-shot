extends Node3D

var isPaused = false

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		isPaused = !isPaused
		if isPaused:
			propagate_notification(NOTIFICATION_PAUSED)
			$CanvasLayer/PauseMenu/PauseBG.visible = true
			$CanvasLayer/PauseMenu/PauseCnt.visible = true
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			$CanvasLayer/PauseMenu/PauseBG.visible = false
			$CanvasLayer/PauseMenu/PauseCnt.visible = false
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			propagate_notification(NOTIFICATION_UNPAUSED)
		
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	var floor_z = $Floor.scale.z/2
	var floor_x = $Floor.global_position.x
	var floor_y = 2.0
	GameManager.zero_team_spawn = Vector3(floor_x,floor_y,floor_z-2)
	GameManager.unit_team_spawn = Vector3(floor_x,floor_y,-floor_z+2)

func _on_continue_pressed() -> void:
	isPaused = false
	$CanvasLayer/PauseMenu/PauseBG.visible = false
	$CanvasLayer/PauseMenu/PauseCnt.visible = false 
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	propagate_notification(NOTIFICATION_UNPAUSED)

func _on_menu_btn_pressed() -> void:
	multiplayer.multiplayer_peer.close()
	get_tree().change_scene_to_file("res://scenes/Menu.tscn")
