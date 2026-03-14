class_name GameMain extends Node2D

@export_category("Nodes")
@export var gameUI: GameUI

@export_category("Starting Stats")
@export var _money: float = 1000

var ticker = 0
var money_cooldown = 4

var game_time_mins = 6
var music_player: AudioStreamPlayer
var event_ticks = 0

signal process_money

var money = _money:
	get:
		return _money
	set(new_money):
		gameUI.set_money(new_money)
		_money = new_money

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	
	gameUI.progress_bar.fill_mode = ProgressBar.FillMode.FILL_BOTTOM_TO_TOP
	gameUI.set_money(money)
	music_player = AudioStreamPlayer.new()
	music_player.stream = load("res://Audio/main-theme-generic.mp3")
	add_child(music_player)
	music_player.play()


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	ticker += delta
	event_ticks += delta
	while (ticker >= money_cooldown):
		process_money.emit()
		ticker -= money_cooldown
	gameUI.progress_bar.set_as_ratio(event_ticks / (60 * game_time_mins))
