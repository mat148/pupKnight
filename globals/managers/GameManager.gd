extends Node2D

@export var state_manager: Node2D
@export var input_manager: Node2D
@export var generation_manager: Node2D
@export var operations_manager: Node2D

#SetupGameState
	#enter()
		#Set up all managers
		#Set up all GUI items
		#State transition > StartMenuState
#StartMenuState
	#ready()
		#start_button_click signal > start_game()
	#start_game()
		#fade out
		#State transition > GenerateWorldState
	#enter()
		#start_GUI signal emit
#GenerateWorldState
	#enter()
		#Generate world
		#place player
		#place enemies
		#State transition >GameRunningState
		#fade in transition
#GameRunningState
	#ready()
		#pause signal > pause_game()
	#pause_game()
		#State transition > PauseGameState
	#enter()
		#player can move
		
#PauseGameState
	#ready()
		#unpause signal > unpause_game()
	#unpause_game()
		#State transition > GameRunningState
	#enter()
		#pause GUI signal emit
	#exit()
		#pause GUI signal emit
#GameOverState


#fade in transition
#game start
	
#start world
	#generate map
	#place player
	#place enemies
	#fade_in transition
