extends Control


# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var gs = get_node("/root/GlobalStats")
	$MarginContainer/TitleBox/StatsLabel.text = \
		"Final: $%.2f" % gs.money \
		+ "\n\nDPs: %d | Grocery Stores: %d" % [gs.dps_placed, gs.gs_placed] \
		+ "\nSpent: $%.2f" % gs.total_spent \
		+ "\n\nPre-COVID: $%.0f (%d sold)" % [gs.earned_pre_covid, gs.food_sold_pre_covid] \
		+ "\nCOVID-19: $%.0f (%d sold)" % [gs.earned_during_covid, gs.food_sold_during_covid]


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass
