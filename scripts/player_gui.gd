extends Control

func _draw() -> void:
	if !is_multiplayer_authority(): return
	var win_size = get_viewport().get_visible_rect().size/2
	draw_circle(win_size,2.0,Color.GREEN)	

func _notification(what: int) -> void:
	if what == NOTIFICATION_PAUSED:
		hide()
	if what == NOTIFICATION_UNPAUSED:
		show()
