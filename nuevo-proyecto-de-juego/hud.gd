extends CanvasLayer

signal start_game

func show_message(text):
	$Message.text = text
	$Message.show()
	$MessageTimer.start()

func update_score(Score):
	$Score.text = str(Score)

func show_game_over():
	
	show_message("Game Over")
	# Wait until the MessageTimer has counted down.
	await $MessageTimer.timeout

	$Message.text = "El Juego de Pepito!"
	$Message.show()
	# Make a one-shot timer and wait for it to finish.
	await get_tree().create_timer(1.0).timeout
	#$Start.show()
	get_tree().change_scene_to_file("res://main.tscn")

func _on_start_pressed() -> void:
	$Start.hide()
	start_game.emit()

func _on_message_timer_timeout() -> void:
	$Message.hide()
