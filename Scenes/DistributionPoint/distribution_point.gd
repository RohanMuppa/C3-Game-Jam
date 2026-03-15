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

@onready var walking_person: PackedScene = preload("res://Scenes/Person/WalkingPerson.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_main.process_money.connect(step)

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
	
	for farm in farms:
		var person: WalkingPerson = walking_person.instantiate()
		person.ready.connect(func():
			person.start(
				person.PersonType.FARMER, game_main.money_cooldown * 2, 
				farm.global_position, global_position
			))
		game_main.add_child(person)
	
	for house in houses:
		var person: WalkingPerson = walking_person.instantiate()
		person.ready.connect(func():
			person.start(
				[
					person.PersonType.KID,
					person.PersonType.VOLUNTEER,
					person.PersonType.CUSTOMER,
				].pick_random(), game_main.money_cooldown * 2, 
				house.global_position, global_position
			))
		game_main.add_child(person)
	
	stored_food += get_supply()

	var sold_food = min(get_demand(), stored_food)
	stored_food -= sold_food
	
	game_main.money += sold_food * get_price()

func get_price() -> float:
	var inc_multi = crisis.dp_income_mult
	if inc_multi < 1:
		inc_multi = min(1, inc_multi + 0.1 * resilience_score)
	return 20 * inc_multi * income_bonus

func get_demand() -> int:
	return houses.size() * house_consumption

func get_supply() -> int:
	return farms.size() * food_intake

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		ui.show_dp_upgrades(self)
