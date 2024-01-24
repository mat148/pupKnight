extends Entity

func check_for_entities():
	return $player_area2D.get_overlapping_bodies().filter(
		func(body): 
			return body.name != "TileMap" && body.name != "player" && body.current_room.room_explored == true
	)
