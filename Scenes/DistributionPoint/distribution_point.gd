class_name DistributionPoint extends Upgradeable

@export var houses: Array[House] = []
@export var farms: Array[Farm] = []

var house_consumption: float = 1
var income_bonus: float = 1
var food_intake: float = 3
var resilience_score: float = 0.5
var price = 1.5

var ui: GameUI

@onready var game_main: GameMain = get_tree().root.get_node("Main")
@onready var crisis: CrisisManager = get_tree().root.get_node("Main/CrisisManager")

@onready var walking_person: PackedScene = preload("res://Scenes/Person/WalkingPerson.tscn")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_main.process_money.connect(step)

func step() -> void:
	for farm in farms:
		var person: WalkingPerson = walking_person.instantiate()
		person.ready.connect(func():
			person.start(
				person.PersonType.FARMER, game_main.money_cooldown * 2, 
				farm.global_position, global_position
			))
		game_main.ysort.add_child(person)
	
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
		game_main.ysort.add_child(person)
	
	var earnings = get_profit()
	var sold_food = min(get_demand(), get_supply())
	game_main.money += earnings
	if crisis.current_phase == CrisisManager.Phase.PRE_COVID:
		game_main.earned_pre_covid += earnings
		game_main.food_sold_pre_covid += sold_food
	else:
		game_main.earned_during_covid += earnings
		game_main.food_sold_during_covid += sold_food

func get_profit() -> float:
	var sold_food = min(get_demand(), get_supply())
	return sold_food * get_price()

func get_price() -> float:
	return income_bonus * (price + crisis.dp_price_adjust * (0.5 + resilience_score))
	#if (crisis.dp_income_mult >= 1):
		#return price * income_bonus * crisis.dp_income_mult
	#return price * income_bonus * (1 - (1 - crisis.dp_income_mult) * (1 - resilience_score))

func get_demand() -> float:
	return houses.size() * house_consumption

func get_supply() -> float:
	return farms.size() * food_intake

func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		ui.show_dp_upgrades(self)
