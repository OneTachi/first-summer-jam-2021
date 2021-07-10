extends Node
class_name Walker

const DIRECTIONS = [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN]

var position = Vector2.ZERO
var direction = Vector2.RIGHT
var borders = Rect2()
var step_hist = []
var steps_since_turn = 0
var rooms = []

func _init(starting_position, new_border):
	assert(new_border.has_point(starting_position))
	position = starting_position
	step_hist.append(starting_position)
	borders = new_border

func walk(steps):
	for step in steps:
		if randf() <= .25 or steps_since_turn > 5:
			change_direction()
		elif randf() <= .01:
			if randf() <= .5:
				place_circle_room(position)
			else:
				place_square_room(position)
		if step():
			step_hist.append(position)
		else:
			change_direction()
	
	return step_hist

func step():
	var target_position = position + direction
	if borders.has_point(target_position):
		steps_since_turn += 1
		position = target_position
		return true
	return false

func change_direction():
	steps_since_turn = 0 
	var directions = DIRECTIONS.duplicate()
	directions.erase(direction)
	directions.shuffle()
	direction = directions.pop_front()
	while not borders.has_point(position + direction):
		direction = directions.pop_front()

func create_room(position, size):
	return {position = position, size = size}

func place_square_room(position):
	var size = Vector2(randi() % 6 + 3, randi() % 6 + 3)
	var top_left = (position - size/2).ceil()
	rooms.append(create_room(position, size))
	
	for x in size.x:
		for y in size.y:
			var new_step = top_left + Vector2(x,y)
			if borders.has_point(new_step):
				step_hist.append(new_step)

func place_circle_room(position):
	var size = [Vector2(randi() % 4 + 2, 0), Vector2(randi() % 4 + 4, 1), Vector2(randi() % 4 + 2, 2)]
	var top_left = (position - Vector2(size[0].x, size[2].y)/2).ceil()
	rooms.append(create_room(position, size))
	
	for z in size:
		var new_step = top_left + z
		if borders.has_point(new_step):
			step_hist.append(new_step)

func get_end_room():
	var end_room = rooms.pop_front()
	var start_vector = step_hist.front()
	for room in rooms:
		if start_vector.distance_to(room.position) > start_vector.distance_to(end_room.position):
			end_room = room 
	return end_room
	
