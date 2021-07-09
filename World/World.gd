extends Node2D

onready var tileMap = $TileMap
onready var borders = Rect2(0, 0, (randi() % 6 + 38), (randi() % 6 + 22))

func _ready():
	randomize()
	generate_level()

func generate_level():
	var walker = Walker.new(Vector2(randi() % int(borders.size.x) + 1, randi() % int(borders.size.y) + 1), borders)
	
	for x in range(-2, borders.size.x + 1, 1):
		for y in range(-2, borders.size.y + 1, 1):
			tileMap.set_cellv(Vector2(x,y), 0)
			#yield(get_tree(), "idle_frame")
	
	
	var map = walker.walk(700)
	walker.queue_free()
	for location in map:
		tileMap.set_cellv(location, -1)
		#yield(get_tree(), "idle_frame")
	tileMap.update_bitmask_region(Vector2(-1, -1), borders.end + Vector2(1, 1))

func _input(event):
	if event.is_action_pressed("ui_accept"):
		get_tree().reload_current_scene()
