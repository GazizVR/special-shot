extends Control

func _draw() -> void:
	if !is_multiplayer_authority(): return
	draw_circle(Vector2(0,0),2.0,Color.GREEN)	

func _notification(what: int) -> void:
	if what == NOTIFICATION_PAUSED:
		hide()
	if what == NOTIFICATION_UNPAUSED:
		show()
