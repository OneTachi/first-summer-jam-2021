extends Node2D

onready var tileMap = $TileMap
onready var borders = Rect2(0, 0, (randi() % 20 + 38), (randi() % 20 + 22))

const Player = preload("res://Player/Player.tscn")
const Exit = preload("res://World/ExitDoor.tscn")
const Egg = preload("res://Player/Egg.tscn")

func _ready():
	randomize()
	generate_level()

func generate_level():
	var walker = Walker.new(Vector2(abs((randi() % int(borders.size.x) - 1)), abs(randi() % int(borders.size.y) - 1)), borders)
	
	for x in range(-2, borders.size.x + 1, 1):
		for y in range(-2, borders.size.y + 1, 1):
			tileMap.set_cellv(Vector2(x,y), 0)
			#yield(get_tree(), "idle_frame")
	
	var map = walker.walk(randi() % 400 + 800)
	
	#instancing objects
	instance_player(map.front()*32)
	instance_exit_door(walker.rooms.back().position*32, walker)
	instance_egg(map.front()*32)
	
	walker.queue_free()
	for location in map:
		tileMap.set_cellv(location, -1)
		#yield(get_tree(), "idle_frame")
	tileMap.update_bitmask_region(Vector2(-1, -1), borders.end + Vector2(1, 1))

func reload_level():
	get_tree().reload_current_scene()

func _input(event):
	if event.is_action_pressed("ui_accept"):
		reload_level()

func instance_player(position):
	var player = Player.instance()
	add_child(player)
	player.position = position + Vector2(16, 16)

func instance_exit_door(position, walker):
	var exit = Exit.instance()
	add_child(exit)
	exit.position = walker.get_end_room().position*32
	exit.connect("leaving_level", self, "reload_level")

func instance_egg(position):
	var egg = Egg.instance()
	add_child(egg)
	egg.position = position
