extends Node2D
class_name Room

@export var area2D: Area2D
@export var collisionPolygon2D: CollisionPolygon2D
@export var fog: Polygon2D

var room_rect: Rect2
var room_index: int
var room_explored: bool

func _on_area_2d_body_entered(body):
	if body.is_in_group("entity"):
		body.current_room = self
	
	if body.name == 'player' && !room_explored:
		room_explored = true
		fog.queue_free()
