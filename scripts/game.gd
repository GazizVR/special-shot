extends Node3D

var isPaused = false

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		isPaused = !isPaused
		if isPaused:
			propagate_notification(NOTIFICATION_PAUSED)
			$CanvasLayer/ScoreControl.visible = false
			$CanvasLayer/PauseMenu.visible = true
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			$CanvasLayer/PauseMenu.visible = false
			$CanvasLayer/ScoreControl.visible = true
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
			propagate_notification(NOTIFICATION_UNPAUSED)
		
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	var floor_z = $Floor.scale.z/2
	var floor_x = $Floor.global_position.x
	var floor_y = 2.0
	GameManager.zero_team_spawn = Vector3(floor_x,floor_y,floor_z-2)
	GameManager.unit_team_spawn = Vector3(floor_x,floor_y,-floor_z+2)
	var sensitivity = GameManager.camera_sensitivity
	$CanvasLayer/PauseMenu/PauseCnt/SensContainer/HSlider.value = sensitivity
	$CanvasLayer/PauseMenu/PauseCnt/SensContainer/HBoxContainer/LineEdit.text = str(sensitivity)
	GameManager.team_score_changed.connect(score_changed)

func score_changed(team: GameManager.Team):
	if team == GameManager.Team.ZERO:
		var score_str: String = $CanvasLayer/ScoreControl/HBoxContainer/ZeroTScore.text
		var score = score_str.to_int() 
		$CanvasLayer/ScoreControl/HBoxContainer/ZeroTScore.text = str(score+1)
	if team == GameManager.Team.UNIT:
		var score_str: String = $CanvasLayer/ScoreControl/HBoxContainer/UnitTScore.text
		var score = score_str.to_int() 
		$CanvasLayer/ScoreControl/HBoxContainer/UnitTScore.text = str(score+1)

func _on_continue_pressed() -> void:
	isPaused = false
	$CanvasLayer/PauseMenu.visible = false
	$CanvasLayer/ScoreControl.visible = true
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
	propagate_notification(NOTIFICATION_UNPAUSED)

func _on_menu_btn_pressed() -> void:
	multiplayer.multiplayer_peer.close()
	get_tree().change_scene_to_file("res://scenes/menu.tscn")

func _on_h_slider_value_changed(value: float) -> void:
	GameManager.camera_sensitivity = value
	$CanvasLayer/PauseMenu/PauseCnt/SensContainer/HBoxContainer/LineEdit.text = str(value)

func _on_line_edit_text_changed(new_text: String) -> void:
	var value = GameManager.camera_sensitivity
	if new_text.is_valid_float():
		var new_float = new_text.to_float()
		if new_float > 0.0009 and new_float <= 1.0:
			value = new_float
	$CanvasLayer/PauseMenu/PauseCnt/SensContainer/HBoxContainer/LineEdit.text = str(value)
	if value != GameManager.camera_sensitivity:
		GameManager.camera_sensitivity = value
		$CanvasLayer/PauseMenu/PauseCnt/SensContainer/HSlider.value = value
