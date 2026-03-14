extends Control

@export var upgrades: Node

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if Input.is_action_just_pressed("close_upgrade_window"):
		visible = false
	


func inherit_upgrades(ug: Upgradeable) -> void:
	for upgrade: UpgradeButton in upgrades.get_children():
		upgrade.purchased = upgrade.name in ug.upgrades
		upgrade.ug = ug
	$MarginContainer/Stats.ug = ug
