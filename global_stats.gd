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
var blob_url: String = "https://jsonblob.com/api/jsonBlob/019cf2b8-b70d-76f3-97cb-3055616f3fd4"
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
	var body = JSON.stringify({"money": money, "dps": dps_placed, "gs": gs_placed, "spent": total_spent, "phase": phase})
	http.request(blob_url, ["Content-Type: application/json"], HTTPClient.METHOD_PUT, body)
