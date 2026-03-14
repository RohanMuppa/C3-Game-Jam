class_name GameMain extends Node2D

@export_category("Nodes")
@export var gameUI: GameUI

@export_category("Starting Stats")
@export var _money: float = 1000

@onready var progress_bar: ProgressBar = %ProgressBar

var ticker = 0
var money_cooldown = 3


signal process_money

var money = _money:
	get:
		return _money
	set(new_money):
		gameUI.set_money(new_money)
		_money = new_money

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	progress_bar.fill_mode = ProgressBar.FillMode.FILL_BOTTOM_TO_TOP
	gameUI.set_money(money)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	ticker += delta
	if (ticker >= money_cooldown):
		process_money.emit()
		ticker = 0
	progress_bar.set_as_ratio(Time.get_ticks_msec() / 1000.0 / (60 * 1))
