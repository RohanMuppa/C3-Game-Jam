class_name CustomText extends Node

var icon: CompressedTexture2D
var text: String = ""
var timeout: float = 10

static func create(text: String, timeout: float = 10, icon: CompressedTexture2D = null) -> CustomText:
	var a = CustomText.new()
	a.text = text
	a.timeout = timeout
	a.icon = icon
	return a
