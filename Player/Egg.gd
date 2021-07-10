extends KinematicBody2D

onready var player = $"../Player"
onready var anim = $AnimationPlayer
onready var coll_shape = $CollisionShape2D

enum {
	CARRY,
	THROW,
	ON_FLOOR
}
var state = CARRY
var mouse_position
var direction = Vector2.ZERO


func _physics_process(delta):
	match state:
		CARRY:
			global_position = player.position + Vector2(0, -5)
			anim.play("carried")
		
		THROW:
			var distance = position.distance_to(mouse_position)
			move_and_slide(direction * 50)
			if distance < 5 or is_on_wall():
				state = ON_FLOOR
		
		ON_FLOOR:
			pass

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and state == CARRY:
		mouse_position = get_global_mouse_position()
		var egg_position = self.global_position
		direction = egg_position.direction_to(mouse_position) 
		state = THROW
		anim.play("still")
