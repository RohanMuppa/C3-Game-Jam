class_name UpgradeButton extends Button

@export var cost: int
@export var on_purchase: UpgradeResource
@export var parent: UpgradeButton

@onready var game_main: GameMain = get_tree().root.get_node("Main")

var purchased: bool = false

func _ready() -> void:
	text += " ($%d)" % (cost)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _draw() -> void:
	if parent:
		draw_line(Vector2.ZERO, parent.global_position - global_position, Color.BLACK)

func _pressed() -> void:
	if game_main.money < cost || purchased || (parent && !parent.purchased):
		return
	game_main.money -= cost
	on_purchase.purchase_upgrade(game_main)
	purchased = true
