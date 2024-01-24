extends State
class_name StartMenuState

func _ready():
	SignalManager.start_game_button_clicked.connect(start_game)

func start_game():
	SignalManager.transition_out.emit()
	await get_tree().create_timer(0.83).timeout
	Transitioned.emit(self, "GenerateWorldState")

func enter():
	SignalManager.start_GUI.emit()

func exit():
	SignalManager.start_GUI.emit()
