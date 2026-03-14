class_name GameUI extends Control

@export var moneyCtr: RichTextLabel

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_money(money: float) -> void:
	moneyCtr.text = "$%.2f" % (money)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
