extends Control

var isPaused = false

func _input(event: InputEvent) -> void:
	if Input.is_action_just_pressed("pause"):
		isPaused = !isPaused
		if isPaused:
			$PauseBG.visible = true
			$PauseCnt.visible = true
			Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		else:
			$PauseBG.visible = false
			$PauseCnt.visible = false 
			Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		get_tree().paused = isPaused
func _ready() -> void:
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_continue_pressed() -> void:
	isPaused = false
	get_tree().paused = isPaused
	$PauseBG.visible = false
	$PauseCnt.visible = false 
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED


func _on_menu_btn_pressed() -> void:
	isPaused = false
	get_tree().paused = isPaused
	$PauseBG.visible = false
	$PauseCnt.visible = false
	Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
	get_tree().change_scene_to_file("res://scenes/menu.tscn")
