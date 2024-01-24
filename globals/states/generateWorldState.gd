extends State

func _ready():
	SignalManager.done_generating.connect(done_generating)

func enter():
	SignalManager.generate_map.emit()

func exit():
	SignalManager.transition_in.emit()
	await get_tree().create_timer(0.83).timeout

func done_generating():
	Transitioned.emit(self, "GameRunningState")
