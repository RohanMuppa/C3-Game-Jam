class_name CrisisManager extends Node
# class made by claude. This class has phase transitions, modifer variables, and formulas for other files

signal phase_changed(phase_name: String)

enum Phase { PRE_COVID, DURING_COVID, POST_COVID }

var current_phase: Phase = Phase.PRE_COVID
var phase_timer: float = 0.0
var phase_duration: float = 120.0

var farm_production_mult: float = 1.0
var dp_income_mult: float = 1.0
var grocery_income_mult: float = 1.0
var import_supply_mult: float = 1.0
var dp_cost_mult: float = 1.0

@onready var game_main: GameMain = get_tree().root.get_node("Main")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	phase_duration = game_main.game_time_mins * 60.0 / 3.0
	enter_phase(Phase.PRE_COVID)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	phase_timer += delta

	if phase_timer >= phase_duration:
		match current_phase:
			Phase.PRE_COVID:
				enter_phase(Phase.DURING_COVID)
			Phase.DURING_COVID:
				enter_phase(Phase.POST_COVID)

func enter_phase(phase: Phase):
	current_phase = phase
	phase_timer = 0.0
	reset_modifiers()

	match phase:
		Phase.PRE_COVID:
			phase_changed.emit("Pre-COVID")
		Phase.DURING_COVID:
			grocery_income_mult = 0.4
			import_supply_mult = 0.3
			farm_production_mult = 0.8
			dp_cost_mult = 1.3
			phase_changed.emit("COVID-19")
		Phase.POST_COVID:
			dp_income_mult = 1.3
			phase_changed.emit("Post-COVID")

func reset_modifiers():
	farm_production_mult = 1.0
	dp_income_mult = 1.0
	grocery_income_mult = 1.0
	import_supply_mult = 1.0
	dp_cost_mult = 1.0
