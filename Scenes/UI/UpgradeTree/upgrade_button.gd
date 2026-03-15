class_name UpgradeButton extends Button

@export var cost: int
@export var on_purchase: UpgradeResource
@export var parent: UpgradeButton
@export var desc: String

var children: Array[UpgradeButton]

@onready var game_main: GameMain = get_tree().root.get_node("Main")
@onready var line: LineDrawer = $Line
@onready var tooltip: PanelContainer = $Tooltip
@onready var tooltipText: RichTextLabel = $Tooltip/MarginContainer/RichTextLabel

@onready var purchased_stylebox: StyleBox = preload("res://Themes/ButtonBoxes/purchased.tres")
@onready var locked_stylebox: StyleBox = preload("res://Themes/ButtonBoxes/locked.tres")

var _purchased: bool = false
var purchased: bool = _purchased:
	get:
		return _purchased
	set(new_val):
		_purchased = new_val
		if _purchased:
			disabled = true
			add_theme_stylebox_override("disabled", purchased_stylebox)
		else:
			add_theme_stylebox_override("disabled", locked_stylebox)
			if parent && !parent._purchased:
				disabled = true
			else:
				disabled = false
var ug: Upgradeable

func _ready() -> void:
	tooltipText.text = desc
	text += " ($%d)" % (cost)
	if parent:
		line.to = parent.line
		line.queue_redraw()
		parent.children.append(self)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func _pressed() -> void:
	if game_main.money < cost || purchased || (parent && !parent.purchased):
		return
	game_main.money -= cost
	on_purchase.purchase_upgrade(game_main, ug)
	ug.upgrades.append(name)
	purchased = true
	
	for child in children:
		child.disabled = false

func _on_mouse_entered() -> void:
	tooltip.visible = true

func _on_mouse_exited() -> void:
	tooltip.visible = false
