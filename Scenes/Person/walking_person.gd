class_name WalkingPerson extends Node2D

var speed: float = 0
var t: float = 0
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

enum PersonType {
	KID,
	FARMER,
	VOLUNTEER,
	TRUCK,
}

var _start: Vector2 = Vector2.ZERO
var _end: Vector2 = Vector2.ZERO
var _loop: bool = false

var animation_name: String
var animation_type: PersonType

func start(person: PersonType, time: float, start: Vector2, end: Vector2, loop=true):
	animation_type = person
	match (person):
		PersonType.KID:
			sprite.play("Kid")
		PersonType.FARMER:
			sprite.play("Farmer")
		PersonType.VOLUNTEER:
			sprite.play("Volunteer")
		PersonType.TRUCK:
			animation_name = [
				"GrainTruck", "MeatTruck", "TomatoTruck"
			].pick_random()
			sprite.play(animation_name)
	
	speed = time
	if loop:
		speed /= 2
	_start = start
	_end = end
	_loop = loop
	t = 0
	global_position = _start
	visible = true
	
	# 133 is just a magic number that looks good
	sprite.speed_scale = _start.distance_to(_end) / 133

func _physics_process(delta: float) -> void:
	t += delta / speed
	if t > 1 + (1 if _loop else 0):
		queue_free()
		return
	
	var target = _end
	if t > 1:
		target = _start
		global_position = _end.lerp(_start, t - 1)
	else:
		global_position = _start.lerp(_end, t)
	
	sprite.flip_h = global_position.x > target.x
	if animation_type == PersonType.TRUCK:
		if global_position.y >= target.y:
			sprite.play(animation_name + "B")
		else:
			sprite.play(animation_name)
	
