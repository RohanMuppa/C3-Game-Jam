class_name GroceryStore extends Upgradeable

@export var houses: Array[House] = []
@export var imports: Array[Import] = []

var ui: GameUI

@onready var game_main: GameMain = get_tree().root.get_node("Main")
@onready var crisis: CrisisManager = get_tree().root.get_node("Main/CrisisManager")

@onready var walking_person: PackedScene = preload("res://Scenes/Person/WalkingPerson.tscn")

var house_consumption: int = 1
var income_bonus: float = 1
var food_intake: int = 5

var resilience_score: float = 0.45
var price = 8
var wages: float = 5

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
	

	var sold_food = min(get_demand(), get_supply())

	game_main.money += sold_food * get_price() - wages * houses.size()

func get_profit() -> float:
	var sold_food = min(get_demand(), get_supply())
	return sold_food * get_price() - wages * houses.size()

func get_demand() -> int:
	return houses.size() * house_consumption

func get_supply() -> int:
	return food_intake * (1 - (1 - crisis.import_supply_mult) * (1 - resilience_score))

func get_price() -> float:
	return price * income_bonus * (1 - (1 - crisis.grocery_income_mult) * (1 - resilience_score))

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
