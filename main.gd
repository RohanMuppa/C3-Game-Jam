class_name GameMain extends Node2D

@export_category("Nodes")
@export var gameUI: GameUI

@export_category("Starting Stats")
@export var _money: float = 25

var ticker = 0
var money_cooldown = 4

var game_time_mins = 6
@onready var music_player: AudioStreamPlayer = AudioStreamPlayer.new()
var event_ticks = 0

signal process_money

var money = _money:
	get:
		return _money
	set(new_money):
		gameUI.set_money(new_money)
		_money = new_money

func get_music_player() -> AudioStreamPlayer:
	if (music_player == null):
		music_player = AudioStreamPlayer.new();
	return music_player

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	gameUI.progress_bar.fill_mode = ProgressBar.FillMode.FILL_BOTTOM_TO_TOP
	gameUI.set_money(money)
	get_music_player()
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
