extends Control

func _on_button_pressed():
	SignalManager.start_game_button_clicked.emit()
