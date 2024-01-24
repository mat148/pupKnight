extends CharacterBody2D
class_name Entity

@export var ray: RayCast2D
var setter: Callable = Callable(self, "set_position")

@export var health: int
@export var damage: int

var animation_speed: int = 3
var tile_size: int = 128
var current_room: Room

func move(dir):
	ray.target_position = dir * tile_size
	ray.force_raycast_update()
	
	var entity = ray.get_collider()
	if ray.is_colliding() && entity.is_in_group('entity'):
		entity.damage_entity(damage)

	if !ray.is_colliding():
		var tween = get_tree().create_tween()
		tween.tween_property(self, "position", position + dir * tile_size, 1.0/animation_speed).set_trans(Tween.TRANS_SINE)
		await tween.finished

func damage_entity(dam):
	health -= dam
	
	if self.name == 'player' && health <= 0:
		SignalManager.player_died.emit()
	elif self.is_in_group('enemies') && health <= 0:
		queue_free()
