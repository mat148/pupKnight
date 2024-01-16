extends Node2D

@export var player: Node2D

func _ready():
	SignalManager.player_finished_move.connect(move_enemies)

func move_enemies():
	var enemies = player.check_for_enemies()
	#var enemies = get_tree().get_nodes_in_group("enemies")
	
	for enemy in enemies:
		await enemy.get_parent().move()
	
	SignalManager.enemy_finished_move.emit()
