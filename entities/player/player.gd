extends Area2D

@onready var ray = $player_move_ray

var animation_speed = 3
var moving = false
var tile_size = 128
#var dir = Vector2.ZERO

func _ready():
	SignalManager.player_input.connect(move)
	SignalManager.enemy_finished_move.connect(toggle_moving)
	position = position.snapped(Vector2.ONE * tile_size)

func toggle_moving():
	moving = false

#func _input(event):
	#if !event.is_pressed() || moving:
		#dir = Vector2.ZERO
		#return
	
	#if event.is_action("left"):
		#dir = Vector2.LEFT
		#SignalManager.player_check_tile.emit(dir)
	
	#if event.is_action("right"):
		#dir = Vector2.RIGHT
		#SignalManager.player_check_tile.emit(dir)
	
	#if event.is_action("up"):
		#dir = Vector2.UP
		#SignalManager.player_check_tile.emit(dir)
	
	#if event.is_action("down"):
		#dir = Vector2.DOWN
		#SignalManager.player_check_tile.emit(dir)

func move(dir):
	if !moving:
		ray.target_position = dir * tile_size
		ray.force_raycast_update()
		
		if ray.is_colliding():
			print(ray.get_collider())
		
		if !ray.is_colliding():
			var tween = get_tree().create_tween()
			tween.tween_property(self, "position", position + dir * tile_size, 1.0/animation_speed).set_trans(Tween.TRANS_SINE)
			moving = true
			await tween.finished
			SignalManager.player_finished_move.emit()
			#moving = false
