extends Node
class_name Walker

const DIRECTIONS = [Vector2.RIGHT, Vector2.LEFT, Vector2.UP, Vector2.DOWN]

var position = Vector2.ZERO
var direction = Vector2.RIGHT
var borders = Rect2()
var step_hist = []
var steps_since_turn = 0

func _init(starting_position, new_border):
	assert(new_border.has_point(starting_position))
	position = starting_position
	step_hist.append(starting_position)
	borders = new_border

func walk(steps):
	for step in steps:
		if randf() <= .25 or steps_since_turn > 3:
			change_direction()
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
