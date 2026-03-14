class_name DistributionPoint extends Upgradeable

@export var houses: Array[House] = []
@export var farms: Array[Farm] = []

var ticker: float = 0.0
var cash_interval: float = 3
var stored_food: int = 0
var ui: GameUI

@onready var game_main: GameMain = get_tree().root.get_node("Main")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_main.process_money.connect(step)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()

func step() -> void:
	stored_food += 3 * farms.size()
	
	var sold_food = min(houses.size(), stored_food)
	stored_food -= sold_food
	
	game_main.money += 50 * sold_food

func _draw() -> void:
	for house in houses:
		draw_line(
			Vector2.ZERO,
			house.global_position - global_position,
			Color.CRIMSON
		)
	
	for farm in farms:
		draw_line(
			Vector2.ZERO,
			farm.global_position - global_position,
			Color.DARK_ORANGE
		)

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		ui.show_dp_upgrades(self)
