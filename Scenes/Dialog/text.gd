class_name CustomText extends Node
var text: String = ""
var timeout: float = 10

static func create(text: String, timeout: float = 10) -> CustomText:
	var a = CustomText.new()
	a.text = text
	a.timeout = timeout
	return a
