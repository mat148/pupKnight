extends Area2D

@onready var ray = $player_move_ray

var animation_speed = 3
var moving = false
var tile_size = 128
var inputs = {
	"right": Vector2.RIGHT,
	"left": Vector2.LEFT,
	"up": Vector2.UP,
	"down": Vector2.DOWN
}

func _ready():
	position = position.snapped(Vector2.ONE * tile_size)

func _unhandled_input(event):
	if moving: return
	for dir in inputs.keys():
		if event.is_action_pressed(dir, false, true):
			move(dir)

func move(dir):
	ray.target_position = inputs[dir] * tile_size
	ray.force_raycast_update()
	
	if !ray.is_colliding():
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", position + inputs[dir] * tile_size, 1.0/animation_speed).set_trans(Tween.TRANS_SINE)
		moving = true
		await tween.finished
		moving = false
