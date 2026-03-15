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

var server: TCPServer = TCPServer.new()
var port: int = 8080
var local_ip: String = ""
var qr_texture: ImageTexture = null

func _ready() -> void:
	local_ip = get_local_ip()
	server.listen(port)
	generate_qr()

func _process(delta: float) -> void:
	if server.is_connection_available():
		var client = server.take_connection()
		var html = build_page()
		var resp = "HTTP/1.1 200 OK\r\nContent-Type: text/html\r\n\r\n" + html
		client.put_data(resp.to_utf8_buffer())
		client.disconnect_from_host()

func get_local_ip() -> String:
	for addr in IP.get_local_addresses():
		if addr.begins_with("192.168") or addr.begins_with("10."):
			return addr
	return "localhost"

func get_url() -> String:
	return "http://" + local_ip + ":" + str(port)

func generate_qr() -> void:
	var qr = QrCode.new()
	qr.error_correct_level = QrCode.ErrorCorrectionLevel.LOW
	qr_texture = qr.get_texture(get_url())
	qr.queue_free()

func build_page() -> String:
	return "<html><head><meta charset='utf-8'>" \
		+ "<meta http-equiv='refresh' content='2'>" \
		+ "<meta name='viewport' content='width=device-width'>" \
		+ "<style>body{font-family:sans-serif;background:#2f4d2f;color:#f2b888;padding:20px;text-align:center}" \
		+ "h1{color:#fdd179;font-size:2em}h2{color:#fee1b8}.s{font-size:1.2em;margin:8px}</style></head>" \
		+ "<body><h1>Supply Shock</h1>" \
		+ "<h2>" + phase + "</h2>" \
		+ "<div class='s'>Money: $" + str(snapped(money, 0.01)) + "</div>" \
		+ "<div class='s'>DPs: " + str(dps_placed) + " | Stores: " + str(gs_placed) + "</div>" \
		+ "<div class='s'>Spent: $" + str(snapped(total_spent, 0.01)) + "</div>" \
		+ "</body></html>"
