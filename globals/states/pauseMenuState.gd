extends State
class_name PauseMenuState

func _ready():
	SignalManager.unpause_game.connect(unpause_game)

func unpause_game():
	Transitioned.emit(self, "GameRunningState")

func enter():
	SignalManager.pause_GUI.emit()

func exit():
	SignalManager.pause_GUI.emit()
