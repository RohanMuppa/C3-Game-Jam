extends Button

@export var parent: Control

func _pressed() -> void:
	parent.visible = false
