extends State
class_name GameOverState

func _ready():
	SignalManager.restart_game_button_click.connect(restart_game)
	pass

func restart_game():
	SignalManager.transition_out.emit()
	await get_tree().create_timer(0.83).timeout
	Transitioned.emit(self, "GenerateWorldState")

func enter():
	SignalManager.gameover_GUI.emit()
	print("GameOver")

func exit():
	SignalManager.gameover_GUI.emit()
