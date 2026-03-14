class_name GroceryStore extends Upgradeable

@export var houses: Array[House] = []
@export var imports: Array[Import] = []

var stored_food: int = 0
var ui: GameUI

@onready var game_main: GameMain = get_tree().root.get_node("Main")
@onready var crisis: CrisisManager = get_tree().root.get_node("Main/CrisisManager")

@onready var walking_person: PackedScene = preload("res://Scenes/Person/WalkingPerson.tscn")

var house_consumption: int = 1
var income_bonus: float = 1.0
var food_intake: int = 5

# Resilience score is hidden
# DP base = 3, GS base = 1
# Resilience has a range of [-10, 10]
var resilience_score: float = 1

# cost of paying workers during crisis
var wages: float = 350

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	game_main.process_money.connect(step)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	queue_redraw()

func step() -> void:
	for import in imports:
		var person: WalkingPerson = walking_person.instantiate()
		person.ready.connect(func():
			person.start(
				person.PersonType.TRUCK, game_main.money_cooldown * 2, 
				import.global_position, global_position
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

func get_demand() -> int:
	return houses.size() * house_consumption

func get_supply() -> int:
	var supply_multi = crisis.import_supply_mult
	if supply_multi < 1:
		supply_multi = min(1, supply_multi + 0.1 * resilience_score)
		
	return int(food_intake * imports.size() * supply_multi)

func get_price() -> float:
	var inc_multi = crisis.grocery_income_mult
	if inc_multi < 1:
		inc_multi = min(1, inc_multi + 0.1 * resilience_score)
	return 35 * income_bonus * inc_multi

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


func _on_area_2d_input_event(viewport: Node, event: InputEvent, shape_idx: int) -> void:
	if event is InputEventMouseButton and event.button_index == MOUSE_BUTTON_LEFT and event.is_pressed():
		ui.show_gs_upgrades(self)
