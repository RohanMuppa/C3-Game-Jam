class_name GameMain extends Node2D

@export_category("Nodes")
@export var gameUI: GameUI

@export_category("Starting Stats")
@export var _money: float = 25

var ticker = 0
var money_cooldown = 4

var game_time_mins = 6

var earned_pre_covid: float = 0
var earned_during_covid: float = 0
var food_sold_pre_covid: int = 0
var food_sold_during_covid: int = 0
var dps_placed: int = 0
var gs_placed: int = 0
var total_spent: float = 0
var upgrades_purchased: int = 0
var resilience_upgrades: int = 0
var income_upgrades: int = 0
var sent_first_msg = false
@onready var music_player: AudioStreamPlayer = AudioStreamPlayer.new()
@onready var dialog_box: = $Dialog/CanvasLayer/DialogBox
@onready var dpPreview = get_tree().get_nodes_in_group("DP_Preview")[0]
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
	var ratio = event_ticks / (60 * game_time_mins)
	gameUI.progress_bar.set_as_ratio(ratio)
	
	if ratio > 0.2 && dialog_box.visible == false && dpPreview.first_dp == false && sent_first_msg == false:
		var arr: Array[CustomText] = [
			CustomText.create("NameA: [Farmer], good to see you again! Can I just say your tomatoes have never been better! [NameB] loves them, don’t you?", 4),
			CustomText.create("NameB: Tomatoes, tomatoes! ", 4),
			CustomText.create("Farmer: That’s great to hear from such a long-time customer. [NameB], next week, I’ll save my best tomato just for you; how’s that sound?", 4)
		]
		dialog_box.set_text(arr)
		sent_first_msg = true
		
