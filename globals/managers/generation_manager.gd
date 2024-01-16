extends Node2D

const tile_size = 128
const min_room_size = 5
const max_room_size = 8

@export var tile: Dictionary = {}
@export var enemy_reference: PackedScene

var level_num = 0
var map = []
var rooms = []
var level_size = Vector2(60, 60)

## TODO Move to groups
#var enemies = []

@export var tile_map: TileMap
@export var player: Area2D

#var player_tile
var score = 0

func _ready():
	#SignalManager.player_check_tile.connect(check_tile)
	
	randomize()
	build_level()

func check_tile(dir):
	print('check tile: ', dir)
	var x = player.position.x + dir.x
	var y = player.position.y + dir.y
	
	var tile_type = tile.stone
	if x >= 0 && x < level_size.x && y >= 0 && y < level_size.y:
		tile_type = map[x][y]
	
	match tile_type:
		tile.door:
			set_tile(x, y, tile.floor)
		
		#tile.ladder:
			#pass

func build_level():
	rooms.clear()
	map.clear()
	tile_map.clear()
	
	for x in range(level_size.x):
		map.append([])
		for y in range(level_size.y):
			map[x].append(tile.stone)
			tile_map.set_cell(0, Vector2i(x, y), 0, tile.stone)
	
	var free_regions: Array[Rect2] = [Rect2(Vector2(2,2), level_size - Vector2(4,4))]
	var num_rooms = 1000
	for i in range(num_rooms):
		add_room(free_regions)
		if free_regions.is_empty():
			break
	
	connect_rooms()
	
	# Place player
	var start_room = rooms.front()
	var player_x = start_room.position.x + 1 + randi() % int(start_room.size.x - 2)
	var player_y = start_room.position.y + 1 + randi() % int(start_room.size.y - 2)
	player.position = Vector2(player_x, player_y) * tile_size
	
	# Place enemies
	var num_enemies = 50
	for i in range(num_enemies):
		var room = rooms[1 + randi() % (rooms.size() - 1)]
		var x = room.position.x + 1 + randi() % int(room.size.x - 2)
		var y = room.position.y + 1 + randi() % int(room.size.y - 2)
		
		var blocked = false
		for enemy in get_tree().get_nodes_in_group("enemies"):
			if enemy.position.x == x && enemy.position.y == y:
				blocked = true
				break
			
		if !blocked:
			var enemy = enemy_reference.instantiate()
			enemy.position = Vector2(x, y) * tile_size
			enemy.add_to_group("enemies")
			get_node("/root/Main/enemy_container").add_child(enemy)
			#var enemy = Enemy.new(self, randi() % 2, x, y)
			#enemies.append(enemy)
	
	#call_deferred("update_visuals")

func update_visuals():
	#player.position = player_tile * tile_size
	pass

func connect_rooms():
	var stone_graph = AStar2D.new()
	var point_id = 0
	for x in range(level_size.x):
		for y in range(level_size.y):
			if map[x][y] == tile.stone:
				stone_graph.add_point(point_id, Vector2(x, y))
				
				if x > 0 && map[x -1][y] == tile.stone:
					var left_point = stone_graph.get_closest_point(Vector2(x - 1, y))
					stone_graph.connect_points(point_id, left_point)
				
				if y > 0 && map[x][y - 1] == tile.stone:
					var above_point = stone_graph.get_closest_point(Vector2(x, y - 1))
					stone_graph.connect_points(point_id, above_point)
				
				point_id += 1
	
	var room_graph = AStar2D.new()
	point_id = 0
	for room in rooms:
		var room_center = room.position + room.size / 2
		room_graph.add_point(point_id, Vector2(room_center.x, room_center.y))
		point_id += 1
	
	while !is_everything_connected(room_graph):
		add_random_connection(stone_graph, room_graph)

func is_everything_connected(graph):
	var points = graph.get_point_ids()
	var start = points[points.size() - 1]
	points.remove_at(points.size() - 1)
	for point in points:
		var path = graph.get_point_path(start, point)
		if !path: return false
	return true

func add_random_connection(stone_graph, room_graph):
	# Pick rooms to connect

	var start_room_id = get_least_connected_point(room_graph)
	var end_room_id = get_nearest_unconnected_point(room_graph, start_room_id)
	
	# Pick door locations
	
	var start_position = pick_random_door_location(rooms[start_room_id])
	var end_position = pick_random_door_location(rooms[end_room_id])
	
	# Find a path to connect the doors to each other
	
	var closest_start_point = stone_graph.get_closest_point(start_position)
	var closest_end_point = stone_graph.get_closest_point(end_position)
	
	var path = stone_graph.get_point_path(closest_start_point, closest_end_point)
	assert(path)
	
	# Add path to the map
	
	path = Array(path)
	
	set_tile(start_position.x, start_position.y, tile.door)
	set_tile(end_position.x, end_position.y, tile.door)
	
	for path_position in path:
		set_tile(path_position.x, path_position.y, tile.ground)
	
	room_graph.connect_points(start_room_id, end_room_id)

func get_least_connected_point(graph):
	var point_ids = graph.get_point_ids()
	
	var least
	var tied_for_least = []
	
	for point in point_ids:
		var count = graph.get_point_connections(point).size()
		if !least || count < least:
			least = count
			tied_for_least = [point]
		elif count == least:
			tied_for_least.append(point)
			
	return tied_for_least[randi() % tied_for_least.size()]
	
func get_nearest_unconnected_point(graph, target_point):
	var target_position = graph.get_point_position(target_point)
	var point_ids = graph.get_point_ids()
	
	var nearest
	var tied_for_nearest = []
	
	for point in point_ids:
		if point == target_point:
			continue
		
		var path = graph.get_point_path(point, target_point)
		if path:
			continue
			
		var dist = (graph.get_point_position(point) - target_position).length()
		if !nearest || dist < nearest:
			nearest = dist
			tied_for_nearest = [point]
		elif dist == nearest:
			tied_for_nearest.append(point)
			
	return tied_for_nearest[randi() % tied_for_nearest.size()]

func pick_random_door_location(room):
	var options = []
	
	# Top and bottom walls
	
	for x in range(room.position.x + 1, room.end.x - 2):
		options.append(Vector2(x, room.position.y))
		options.append(Vector2(x, room.end.y - 1))
			
	# Left and right walls
	
	for y in range(room.position.y + 1, room.end.y - 2):
		options.append(Vector2(room.position.x, y))
		options.append(Vector2(room.end.x - 1, y))
			
	return options[randi() % options.size()]

func add_room(free_regions):
	var rand = randi() % free_regions.size()
	var region = free_regions[rand]
	
	var size_x = min_room_size
	if region.size.x > min_room_size:
		size_x += randi() % int(region.size.x - min_room_size)
	
	var size_y = min_room_size
	if region.size.y > min_room_size:
		size_y += randi() % int(region.size.y - min_room_size)
	
	size_x = min(size_x, max_room_size)
	size_y = min(size_y, max_room_size)
	
	var start_x = region.position.x
	if region.size.x > size_x:
		start_x += randi() % int(region.size.x - size_x)
	
	var start_y = region.position.y
	if region.size.y > size_y:
		start_y += randi() % int(region.size.y - size_y)
	
	var room = Rect2(start_x, start_y, size_x, size_y)
	rooms.append(room)
	
	for x in range(start_x, start_x + size_x):
		set_tile(x, start_y, tile.wall)
		set_tile(x, start_y + size_y - 1, tile.wall)
	
	for y in range(start_y + 1, start_y + size_y - 1):
		set_tile(start_x, y, tile.wall)
		set_tile(start_x + size_x - 1, y, tile.wall)
		
		for x in range(start_x + 1, start_x + size_x - 1):
			set_tile(x, y, tile.ground)
	
	cut_regions(free_regions, room)

func cut_regions(free_regions, region_to_remove):
	var removal_queue = []
	var addition_queue = []
	
	for region in free_regions:
		if region.intersects(region_to_remove):
			removal_queue.append(region)
			
			var leftover_left = region_to_remove.position.x - region.position.x - 1
			var leftover_right = region.end.x - region_to_remove.end.x - 1
			var leftover_above = region_to_remove.position.y - region.position.y - 1
			var leftover_below = region.end.y - region_to_remove.end.y - 1
			
			if leftover_left >= min_room_size:
				addition_queue.append(Rect2(region.position, Vector2(leftover_left, region.size.y)))
			if leftover_right >= min_room_size:
				addition_queue.append(Rect2(Vector2(region_to_remove.end.x + 1, region.position.y), Vector2(leftover_right, region.size.y)))
			if leftover_above >= min_room_size:
				addition_queue.append(Rect2(region.position, Vector2(region.size.x, leftover_above)))
			if leftover_below >= min_room_size:
				addition_queue.append(Rect2(Vector2(region.position.x, region_to_remove.end.y + 1), Vector2(region.size.x, leftover_below)))
	
	for region in removal_queue:
		free_regions.erase(region)
	
	for region in addition_queue:
		free_regions.append(region)

func set_tile(x, y, type):
	map[x][y] = type
	tile_map.set_cell(0, Vector2i(x, y), 0, type)
