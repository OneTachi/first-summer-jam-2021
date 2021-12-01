extends KinematicBody2D

onready var player = $"../Player"
onready var health_bar = $"../CanvasLayer/HR"
onready var soul_bar = $"../CanvasLayer/SR"
onready var anim = $AnimationPlayer
onready var coll_shape = $CollisionShape2D
onready var hitbox = $Hitbox/CollisionShape2D
onready var hurtbox = $Hurtbox/CollisionShape2D
onready var pickupbox = $Pickupbox/CollisionShape2D

const MAX_SPEED = 120
const MIN_SPEED = 60

enum {
	CARRY,
	THROW,
	ON_FLOOR
}
var state = CARRY
var mouse_position
var direction = Vector2.ZERO
var throw_speed
var min_speed
var max_speed 
var friction = 1

var health setget set_health
var soul setget set_soul

func set_health(value):
	health = value 
	health_bar.rect_size.x = 17.3 * value

func set_soul(value):
	soul = value
	soul_bar.rect_size.x = 1.73 * value

func _ready(): 
	self.health = 10

func _physics_process(delta):
	match state:
		CARRY:
			global_position = player.position + Vector2(0, -5)
			anim.play("carried")
			hitbox.disabled = true
			pickupbox.disabled = true
		
		THROW:
			var distance = position.distance_to(mouse_position)
			move_and_slide(direction * throw_speed)
			throw_speed = clamp(throw_speed - friction, min_speed, max_speed)
			
			if distance < 5:
				min_speed = 0
				friction = 5
			if throw_speed == 0 or is_on_wall():
				state = ON_FLOOR
		
		ON_FLOOR:
			pickupbox.disabled = false

func _input(event):
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and state == CARRY:
		mouse_position = get_global_mouse_position()
		var egg_position = self.global_position
		direction = egg_position.direction_to(mouse_position) 
		anim.play("still")
		
		#Setting Variables
		throw_speed = MAX_SPEED
		max_speed = MAX_SPEED
		min_speed = MIN_SPEED
		state = THROW
		friction = 1
		hitbox.disabled = false


func _on_Pickupbox_body_entered(body):
	if state == ON_FLOOR:
		state = CARRY
	


