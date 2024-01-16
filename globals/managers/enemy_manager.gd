extends Node2D

func _ready():
	SignalManager.player_finished_move.connect(move_enemies)

func move_enemies():
	SignalManager.enemy_finished_move.emit()
