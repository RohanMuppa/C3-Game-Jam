class_name GameMain extends Node2D

@export_category("Nodes")
@export var gameUI: GameUI

@export_category("Starting Stats")
@export var _money: float = 25

@onready var emilija_icon: CompressedTexture2D = preload("res://Sprites/mom.png")
@onready var farmer_icon: CompressedTexture2D = preload("res://Sprites/farmer.png")
@onready var hugo_icon: CompressedTexture2D = preload("res://Sprites/hugo.png")

@onready var ysort: Node2D = $YSort

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
var sent_stage2_dialog = false
var sent_stage3_dialog = false
var scene_playing = false
var cutscene2_played = false



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
	if dpPreview.first_dp == true:
		var arr: Array[CustomText] = [
			CustomText.create("Emilija: A distribution point (Q) helps bring more local foods from farmers, but a grocery store (E) can stock products consistently from the ports. What do you think?" , 10, emilija_icon),
			]
		dialog_box.set_text(arr)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	
	if scene_playing == false:
		ticker += delta
		event_ticks += delta
		while (ticker >= money_cooldown):
			process_money.emit()
			ticker -= money_cooldown
		var ratio = event_ticks / (60 * game_time_mins)
		gameUI.progress_bar.set_as_ratio(ratio)
	
		if ratio > 0.2 && dialog_box.visible == false && dpPreview.first_dp == false && sent_first_msg == false:
			var arr: Array[CustomText] = [
				CustomText.create("Emilija: Farmer Zemnieks, good to see you again! Can I just say your tomatoes have never been better! Hugo loves them, don’t you?", 10, emilija_icon),
				CustomText.create("Hugo: Tomatoes, tomatoes! ", 10, hugo_icon),
				CustomText.create("Farmer Zemnieks: That’s great to hear from such a long-time customer. Hugo, next week, I’ll save my best tomato just for you; how’s that sound?", 10, farmer_icon)
			]
			dialog_box.set_text(arr)
			sent_first_msg = true
			
		if ratio > 0.33 && cutscene2_played == false:
			scene_playing = true
			cutscene2_played = true  # Set it immediately to prevent multiple triggers
			$Cutscenes/stage2scene.play_scene()
			$Cutscenes/stage2scene.cutscene_finished.connect(_on_s2_finish)
		
		if (ratio > 0.34 && ratio < 0.65 && dialog_box.visible == false && sent_stage2_dialog == false):
			var arr: Array[CustomText] = [
				CustomText.create("Emilija: Oh dear! I better stock up on groceries since we’ll be at home for a while.", 10, emilija_icon),
				CustomText.create("Farmer Zemnieks: Orders have been coming in like crazy! My truck might not make it!", 10, farmer_icon)
			]
			dialog_box.set_text(arr)
			sent_stage2_dialog = true
		
		if (ratio > 0.67 && ratio < 0.99 && dialog_box.visible == false && sent_stage3_dialog == false):
			var arr: Array[CustomText] = [
				CustomText.create("Emilija: Farmer Zemnieks, it’s been a while! I’ve brought Andris this week to help carry such large orders. How is everything?", 10, emilija_icon),
				CustomText.create("Farmer Zemnieks: Business has gotten slower, but thanks to ya regulars, I’ve been able to get by.", 10, farmer_icon),
				CustomText.create("Emilija: We’ll always be here to support. Besides how could we give up such good tomatoes?", 10, emilija_icon)
			]
			dialog_box.set_text(arr)
			sent_stage3_dialog = true
			
func _on_s2_finish():
	scene_playing = false
