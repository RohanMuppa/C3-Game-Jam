class_name CrisisManager extends Node
# class made by claude. This class has phase transitions, modifer variables, and formulas for other files

signal phase_changed(phase_name: String)

enum Phase { PRE_COVID, DURING_COVID }

var current_phase: Phase = Phase.PRE_COVID
var phase_timer: float = 0.0
var phase_duration: float = 120.0

var dp_price_adjust: float = 0.0
var gs_income_adjust: float = 0.0
var gs_supply_adjust: float = 0.0

var dp_income_mult: float = 1.0
var grocery_income_mult: float = 1.0
var import_supply_mult: float = 1.0
var wage_mult: float = 1.0

var multiplier: float = 1.0

var time_since_COVID = 0

@onready var game_main: GameMain = get_tree().root.get_node("Main")
var main_theme = load("res://Audio/main-theme-generic.mp3")
var covid_theme = load("res://Audio/covid-theme.mp3")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	phase_duration = game_main.game_time_mins * 60.0 / 3.0
	phase_changed.connect(game_main.gameUI.set_phase)
	enter_phase(Phase.PRE_COVID)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	phase_timer += delta

	if phase_timer >= phase_duration:
		match current_phase:
			Phase.PRE_COVID:
				enter_phase(Phase.DURING_COVID)
				phase_duration *= 2
			Phase.DURING_COVID:
				var gs = get_node("/root/GlobalStats")
				gs.money = game_main.money
				gs.dps_placed = game_main.dps_placed
				gs.gs_placed = game_main.gs_placed
				gs.total_spent = game_main.total_spent
				gs.earned_pre_covid = game_main.earned_pre_covid
				gs.earned_during_covid = game_main.earned_during_covid
				gs.food_sold_pre_covid = game_main.food_sold_pre_covid
				gs.food_sold_during_covid = game_main.food_sold_during_covid
				get_tree().change_scene_to_file("res://Scenes/EndScreen/EndScreen.tscn")
	if (current_phase == Phase.DURING_COVID):
		time_since_COVID += delta
		dp_income_mult = 1.5 - time_since_COVID / 100 * 0.3
		

func enter_phase(phase: Phase):
	current_phase = phase
	phase_timer = 0.0
	reset_modifiers()

	var player = game_main.get_music_player()

	match phase:
		Phase.PRE_COVID:
			player.stream = main_theme
			phase_changed.emit("Pre-COVID")
		Phase.DURING_COVID:
			dp_price_adjust = 0.5
			gs_income_adjust = -0.8
			gs_supply_adjust -0.3
			grocery_income_mult = 0.7
			import_supply_mult = 0.7
			wage_mult = 1
			multiplier = 0.5
			player.stream = covid_theme
			phase_changed.emit("COVID-19")

	player.play()

func reset_modifiers():
	dp_income_mult = 1.0
	grocery_income_mult = 1.0
	import_supply_mult = 1.0
	wage_mult = 1.0
	dp_price_adjust = 0.0
	gs_income_adjust = 0.0
	gs_supply_adjust = 0.0
	multiplier = 1.0
