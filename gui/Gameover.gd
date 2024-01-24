extends Control

func _on_button_pressed():
	SignalManager.restart_game_button_click.emit()
