extends Control

func _draw() -> void:
	if !is_multiplayer_authority(): return
	draw_circle(Vector2(0,0),2.0,Color.GREEN)	

func _process(delta: float) -> void:
	if get_tree().paused:
		hide()
	else: 
		show()
