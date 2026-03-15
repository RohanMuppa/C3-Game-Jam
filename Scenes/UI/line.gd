class_name LineDrawer extends Control

@export var to: Node
@export var color: Color

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func _draw():
	if to:
		draw_line(
			Vector2.ZERO,
			to.global_position - global_position,
			color,
			8
		)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
