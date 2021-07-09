extends Node2D


const N = 1
const E = 2
const S = 4
const W = 8

onready var map = $TileMap

var cell_walls = {Vector2.UP: N, Vector2.DOWN: S, Vector2.LEFT: W, Vector2.RIGHT: E}
var tile_size = 64
var maze_width = 20
var maze_height = 12

func _ready():
	randomize()
	tile_size = map.cell_size
	generate_maze()

func check_neighbors(cell, unvisited):
	var list = []
	for x in cell_walls.keys():
		if cell + x in unvisited:
			list.append(cell + x)
	return list

func generate_maze():
	var unvisited = []
	var stack = []
	map.clear()
	for x in maze_width:
		for y in maze_height:
			unvisited.append(Vector2(x,y))
			map.set_cellv(Vector2(x,y), N|E|S|W)
	var current = Vector2.ZERO
	map.set_cellv(current, -1)
	
	unvisited.erase(current)
	while unvisited:
		var neighbors = check_neighbors(current, unvisited)
		if neighbors.size() > 0:
			var next = neighbors[randi() % neighbors.size()]
			stack.append(current)
			var dir = next - current
			var current_walls = map.get_cellv(current) - cell_walls[dir]
			var next_walls = map.get_cellv(next) - cell_walls[-dir]
			map.set_cellv(current, current_walls)
			map.set_cellv(next, next_walls)
			current = next
			unvisited.erase(current)
		elif stack:
			current = stack.pop_back()
		yield(get_tree(), "idle_frame")
