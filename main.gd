class_name GameMain extends Node2D

@export_category("Nodes")
@export var gameUI: GameUI

@export_category("Starting Stats")
@export var _money: float = 1000

var money = _money:
	get:
		return _money
	set(new_money):
		gameUI.set_money(new_money)
		_money = new_money

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gameUI.set_money(money)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
