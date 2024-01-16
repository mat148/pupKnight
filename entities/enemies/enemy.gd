extends Node2D

@onready var timer: Timer = $Timer

var directions = [
	Vector2.LEFT,
	Vector2.RIGHT,
	Vector2.UP,
	Vector2.DOWN
]

var enemySetter: Callable = Callable(self, "set_position")

func move():
	var dir = directions[randi_range(0, 3)]
	var tween = get_tree().create_tween()
	#tween.tween_callback(enemySetter.bind(position + dir * 128)).set_delay(0.03)
	tween.tween_property(self, "position", position + dir * 128, 1.0/12).set_trans(Tween.TRANS_SINE)
	await tween.finished
	return true
