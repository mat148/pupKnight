extends State
class_name GameRunningState

func _ready():
	SignalManager.pause_game.connect(pause_game)
	SignalManager.player_died.connect(game_over)

func enter():
	SignalManager.can_move.emit()

func pause_game():
	print("pause")
	Transitioned.emit(self, "PauseMenuState")

func game_over():
	Transitioned.emit(self, "GameOverState")
