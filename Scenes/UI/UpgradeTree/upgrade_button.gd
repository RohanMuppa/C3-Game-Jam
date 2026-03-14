class_name UpgradeButton extends Button

@export var cost: int
@export var on_purchase: UpgradeResource
@export var parent: UpgradeButton

@onready var game_main: GameMain = get_tree().root.get_node("Main")
@onready var line: LineDrawer = $Line

var purchased: bool = false

func _ready() -> void:
	text += " ($%d)" % (cost)
	if parent:
		line.to = parent.line
		line.queue_redraw()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _pressed() -> void:
	if game_main.money < cost || purchased || (parent && !parent.purchased):
		return
	game_main.money -= cost
	on_purchase.purchase_upgrade(game_main)
	purchased = true
