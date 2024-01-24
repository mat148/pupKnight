extends Node2D

@export var player: CharacterBody2D

var turnDelay: float = 0.001
var moving: bool = true

func _ready():
	SignalManager.player_input.connect(move)
	SignalManager.can_move.connect(update_move)
	pass

func update_move():
	moving = false

func move(dir):
	if get_parent().get_node("StateManager").current_state.name == "GameRunningState":
		if moving:
			return;
		
		await move_enemies(dir)

func move_enemies(dir):
	moving = true
	
	var entities = player.check_for_entities()
	entities.push_front(player)
	
	for entity in entities:
		if entity != null:
			entity.move(dir)
			await get_tree().create_timer(1.0/entity.animation_speed).timeout
	
	moving = false
