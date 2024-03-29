extends Node2D

func _process(_delta):
	if Input.is_action_pressed("left"):
		SignalManager.player_input.emit(Vector2.LEFT)
	
	if Input.is_action_pressed("right"):
		SignalManager.player_input.emit(Vector2.RIGHT)
	
	if Input.is_action_pressed("up"):
		SignalManager.player_input.emit(Vector2.UP)
	
	if Input.is_action_pressed("down"):
		SignalManager.player_input.emit(Vector2.DOWN)
	
	if Input.is_action_just_pressed("escape"):
		print(get_parent().get_node("StateManager").current_state.name)
		if get_parent().get_node("StateManager").current_state.name == 'GameRunningState':
			SignalManager.pause_game.emit()
		elif get_parent().get_node("StateManager").current_state.name == 'PauseMenuState':
			SignalManager.unpause_game.emit()
