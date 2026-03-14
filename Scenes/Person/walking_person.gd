class_name WalkingPerson extends Node2D

var speed: float = 0
var t: float = 0
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

enum PersonType {
	KID,
	FARMER,
	VOLUNTEER,
}

var _start: Vector2 = Vector2.ZERO
var _end: Vector2 = Vector2.ZERO
var _loop: bool = false

func start(person: PersonType, time: float, start: Vector2, end: Vector2, loop=true):
	match (person):
		PersonType.KID:
			sprite.play("Kid")
		PersonType.FARMER:
			sprite.play("Farmer")
		PersonType.VOLUNTEER:
			sprite.play("Volunteer")
	
	speed = time
	if loop:
		speed /= 2
	_start = start
	_end = end
	_loop = loop
	t = 0
	visible = true

func _physics_process(delta: float) -> void:
	print(t)
	t += delta / speed
	if t > 1 + (1 if _loop else 0):
		queue_free()
		return
	
	if t > 1:
		global_position = _end.lerp(_start, t - 1)
	else:
		global_position = _start.lerp(_end, t)
	
