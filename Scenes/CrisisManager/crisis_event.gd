class_name CrisisEvent extends RefCounted

# Data container for a single crisis event
var title: String
var description: String
var duration: float
var remaining_time: float
# Keys are modifier names. values are multipliers
var modifiers: Dictionary = {}

func _init(p_title: String, p_desc: String, p_duration: float, p_modifiers: Dictionary) -> void:
	title = p_title
	description = p_desc
	duration = p_duration
	remaining_time = p_duration
	modifiers = p_modifiers
