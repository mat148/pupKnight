extends CharacterBody2D

const acceleration = 4.0
var player_movement_timeout = false
var new_position = Vector2()

func _process(delta):
	if !player_movement_timeout && Input.is_action_just_pressed("left"):
		player_movement_timeout = true
		new_position = Vector2(position.x - 128, position.y)
		$player_move_pause.start()
	
	if !player_movement_timeout && Input.is_action_just_pressed("right"):
		player_movement_timeout = true
		new_position = Vector2(position.x + 128, position.y)
		$player_move_pause.start()
	
	if !player_movement_timeout && Input.is_action_just_pressed("up"):
		player_movement_timeout = true
		new_position = Vector2(position.x, position.y - 128)
		$player_move_pause.start()
	
	if !player_movement_timeout && Input.is_action_just_pressed("down"):
		player_movement_timeout = true
		new_position = Vector2(position.x, position.y + 128)
		$player_move_pause.start()
	
	if player_movement_timeout:
		position = lerp(position, new_position, acceleration * delta)

func _on_player_move_pause_timeout():
	print("timer done")
	player_movement_timeout = false
