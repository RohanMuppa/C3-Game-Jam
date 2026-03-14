class_name DistributionPoint extends Upgradeable

@export var houses: Array[House] = []
@export var farms: Array[Farm] = []

var house_consumption: int = 1
var income_bonus: float = 1.0
var food_intake: int = 3

# Resilience score is hidden
# DP base = 3, GS base = 1
# Resilience has a range of [-10, 10]
var resilience_score: float = 3

var stored_food: int = 0
var ui: GameUI

@onready var game_main: GameMain = get_tree().root.get_node("Main")
@onready var crisis: CrisisManager = get_tree().root.get_node("Main/CrisisManager")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_main.process_money.connect(step)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()

func step() -> void:
	# resilience score adds 0.1pts to each multi
	# negatively by crisis
	# e.x. if income multi is 0.5
	# and you have 3 resilience
	# 0.5 + 3 * 0.1 = 0.8
	# if income multi is 0.7
	# and you have 5 resiliecne
	# 0.7 + 5 * 0.1 > 1.0
	# capped at 1.0
	
	var prod_multi = crisis.farm_production_mult
	if prod_multi < 1:
		prod_multi = min(1, prod_multi + 0.1 * resilience_score)
	
	var inc_multi = crisis.dp_income_mult
	if inc_multi < 1:
		inc_multi = min(1, inc_multi + 0.1 * resilience_score)
	
	stored_food += int(food_intake * farms.size() * prod_multi)

	var sold_food = min(houses.size() * house_consumption, stored_food)
	stored_food -= sold_food

	game_main.money += 50 * income_bonus * sold_food * inc_multi

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
