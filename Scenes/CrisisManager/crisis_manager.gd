class_name CrisisManager extends Node

signal crisis_started(crisis: CrisisEvent)
signal crisis_ended(crisis: CrisisEvent)
signal phase_changed(phase_name: String)

enum Phase { PRE_COVID, WAVE_1, EASING, WAVE_2, RECOVERY }

var current_phase: Phase = Phase.PRE_COVID
var phase_timer: float = 0.0
var active_crises: Array[CrisisEvent] = []
var crisis_timer: float = 0.0
var crisis_interval: float = 12.0

var pre_covid_duration: float = 30.0
var wave1_duration: float = 40.0
var easing_duration: float = 20.0
var wave2_duration: float = 40.0

var farm_production_mult: float = 1.0
var dp_income_mult: float = 1.0
var grocery_income_mult: float = 1.0
var import_supply_mult: float = 1.0
var dp_cost_mult: float = 1.0

@onready var game_main: GameMain = get_tree().root.get_node("Main")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	enter_phase(Phase.PRE_COVID)


# Called every frame, delta the elapsed time since the previous frame.
func _process(delta: float) -> void:
	phase_timer += delta
	crisis_timer += delta

	match current_phase:
		Phase.PRE_COVID:
			if phase_timer >= pre_covid_duration:
				enter_phase(Phase.WAVE_1)
		Phase.WAVE_1:
			try_spawn_crisis()
			if phase_timer >= wave1_duration:
				enter_phase(Phase.EASING)
		Phase.EASING:
			if phase_timer >= easing_duration:
				enter_phase(Phase.WAVE_2)
		Phase.WAVE_2:
			try_spawn_crisis()
			if phase_timer >= wave2_duration:
				enter_phase(Phase.RECOVERY)

	tick_crises(delta)

func enter_phase(phase: Phase):
	current_phase = phase
	phase_timer = 0.0
	crisis_timer = 0.0

	for crisis in active_crises.duplicate():
		end_crisis(crisis)

	reset_modifiers()

	match phase:
		Phase.PRE_COVID:
			phase_changed.emit("Pre-COVID - Build your network")
		Phase.WAVE_1:
			grocery_income_mult = 0.5
			import_supply_mult = 0.6
			phase_changed.emit("Wave 1 - Lockdowns begin!")
			start_crisis(CrisisEvent.new(
				"Store Restrictions",
				"People turn to local food networks.",
				15.0, {&"grocery_income_mult": 0.5}
			))
		Phase.EASING:
			grocery_income_mult = 0.75
			phase_changed.emit("Restrictions easing")
		Phase.WAVE_2:
			grocery_income_mult = 0.3
			import_supply_mult = 0.3
			farm_production_mult = 0.8
			dp_cost_mult = 1.3
			phase_changed.emit("Wave 2 - Stricter restrictions!")
			start_crisis(CrisisEvent.new(
				"Border Controls",
				"Global food imports disrupted.",
				20.0, {&"import_supply_mult": 0.3}
			))
		Phase.RECOVERY:
			dp_income_mult = 1.3
			phase_changed.emit("Recovery - Network survived!")

func reset_modifiers():
	farm_production_mult = 1.0
	dp_income_mult = 1.0
	grocery_income_mult = 1.0
	import_supply_mult = 1.0
	dp_cost_mult = 1.0

func try_spawn_crisis():
	if crisis_timer < crisis_interval:
		return
	crisis_timer = 0.0

	var pool: Array[CrisisEvent] = []

	if current_phase == Phase.WAVE_1:
		pool = [
			CrisisEvent.new("Panic Buying", "Demand surges!", 10.0, {&"dp_income_mult": 1.5}),
			CrisisEvent.new("Labor Shortage", "Farm production drops.", 10.0, {&"farm_production_mult": 0.5}),
			CrisisEvent.new("Transport Disruption", "DP income reduced.", 8.0, {&"dp_income_mult": 0.6}),
		]
	elif current_phase == Phase.WAVE_2:
		pool = [
			CrisisEvent.new("Strict Lockdown", "Grocery stores nearly shut.", 12.0, {&"grocery_income_mult": 0.2}),
			CrisisEvent.new("Supply Chain Collapse", "Only local farms can provide.", 12.0, {&"import_supply_mult": 0.1}),
			CrisisEvent.new("Farm Quarantine", "Production drops sharply.", 8.0, {&"farm_production_mult": 0.4}),
		]

	if pool.size() > 0:
		start_crisis(pool[randi() % pool.size()])

func start_crisis(crisis: CrisisEvent):
	active_crises.append(crisis)
	for key in crisis.modifiers:
		var val = get(key)
		if val != null:
			set(key, val * crisis.modifiers[key])
	crisis_started.emit(crisis)

func end_crisis(crisis: CrisisEvent):
	for key in crisis.modifiers:
		var val = get(key)
		var mod = crisis.modifiers[key]
		if val != null and mod != 0:
			set(key, val / mod)
	active_crises.erase(crisis)
	crisis_ended.emit(crisis)

func tick_crises(delta: float):
	for crisis in active_crises.duplicate():
		crisis.remaining_time -= delta
		if crisis.remaining_time <= 0:
			end_crisis(crisis)
