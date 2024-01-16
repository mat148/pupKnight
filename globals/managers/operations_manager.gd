extends Node2D

#func _ready():
	#SignalManager.player_input.connect(player_move)
	#SignalManager.player_finished_move.connect(enemy_move)

#func player_move(dir):
	#SignalManager.player_move.emit(dir)

#func enemy_move():
	#pass

##	Player Input
##	Player
#		Raycast check
#			Interaction (door, ladder)
#		Player moves
##	Enemies
#		Raycast check
#			Interaction (door)?
#		Enemies move
