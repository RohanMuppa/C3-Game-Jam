extends AnimatedSprite2D

var circle_mode: bool = false

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func _draw() -> void:
	if circle_mode:
		draw_circle(Vector2.ZERO, 20, Color(0, 0, 0, 0.5))
