class_name GroceryStore extends Node2D

@export var houses: Array[House] = []
@export var imports: Array[Import] = []

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()

func _draw() -> void:
	for house in houses:
		draw_line(
			Vector2.ZERO,
			house.global_position - global_position,
			Color.CRIMSON
		)
	
	for import in imports:
		draw_line(
			Vector2.ZERO,
			import.global_position - global_position,
			Color.DARK_ORANGE
		)
