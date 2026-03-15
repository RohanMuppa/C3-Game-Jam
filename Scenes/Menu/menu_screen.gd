# made w Claude Code
extends Control

func _ready() -> void:
	var gs = get_node("/root/GlobalStats")
	if gs.qr_texture:
		$QRCode.texture = gs.qr_texture
