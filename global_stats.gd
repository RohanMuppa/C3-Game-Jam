# made w Claude Code
extends Node

var money: float = 0
var dps_placed: int = 0
var gs_placed: int = 0
var total_spent: float = 0
var earned_pre_covid: float = 0
var earned_during_covid: float = 0
var food_sold_pre_covid: int = 0
var food_sold_during_covid: int = 0
var phase: String = "Menu"

var qr_texture: ImageTexture = null
var supa_url: String = "https://ekddyatakcbjigfbcggk.supabase.co/rest/v1/game_stats?id=eq.1"
var supa_key: String = "sb_publishable_HCljEapFwGbpxlHd7fVJ0w_aYm9zlW_"
var page_url: String = "https://rohanmuppa.github.io/C3-Game-Jam/"
var http: HTTPRequest
var push_timer: float = 0.0

func _ready() -> void:
	http = HTTPRequest.new()
	add_child(http)
	generate_qr()

func _process(delta: float) -> void:
	push_timer += delta
	if push_timer >= 2.0:
		push_timer = 0.0
		push_stats()

func generate_qr() -> void:
	var qr = QrCode.new()
	qr.error_correct_level = QrCode.ErrorCorrectionLevel.LOW
	qr_texture = qr.get_texture(page_url)
	qr.queue_free()

func push_stats() -> void:
	var gm = get_tree().root.get_node_or_null("Main")
	var m = gm.money if gm else money
	var d = gm.dps_placed if gm else dps_placed
	var g = gm.gs_placed if gm else gs_placed
	var s = gm.total_spent if gm else total_spent
	var body = JSON.stringify({"money": m, "dps": d, "gs": g, "spent": s, "phase": phase})
	var headers = ["Content-Type: application/json", "apikey: " + supa_key, "Prefer: return=minimal"]
	http.request(supa_url, headers, HTTPClient.METHOD_PATCH, body)
