class_name GameUI extends Control

@export var moneyCtr: RichTextLabel

@onready var progress_bar: ProgressBar = %ProgressBar

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.

func set_money(money: float) -> void:
	moneyCtr.text = "$%.2f" % (money)

func set_phase(phase_name: String) -> void:
	$PhaseLabel.text = phase_name

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
	
func show_end_screen(gm: GameMain) -> void:
	$EndScreen.visible = true
	$EndScreen/FinalScore.text = "Final: $%.2f" % gm.money \
		+ "\n\nDPs: %d | Grocery Stores: %d" % [gm.dps_placed, gm.gs_placed] \
		+ "\nSpent: $%.2f" % gm.total_spent \
		+ "\n\nPre-COVID: $%.0f (%d sold)" % [gm.earned_pre_covid, gm.food_sold_pre_covid] \
		+ "\nCOVID-19: $%.0f (%d sold)" % [gm.earned_during_covid, gm.food_sold_during_covid] \
		+ "\nPost-COVID: $%.0f (%d sold)" % [gm.earned_post_covid, gm.food_sold_post_covid]

func show_dp_upgrades(dp: DistributionPoint):
	$DPUpgradeTree.inherit_upgrades(dp)
	$DPUpgradeTree.visible = true

func show_gs_upgrades(gs: GroceryStore):
	$GSUpgradeTree.inherit_upgrades(gs)
	$GSUpgradeTree.visible = true
