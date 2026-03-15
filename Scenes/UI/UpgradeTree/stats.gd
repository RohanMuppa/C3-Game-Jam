extends RichTextLabel

var ug: Upgradeable

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	if not ug:
		return
	
	var price: float = ug.get_price()
	var supply: float = ug.get_supply()
	var demand: float = ug.get_demand()
	var profit : float = ug.get_profit()
	text = "Profit: $%.2f\nPrice: $%.2f\nSupply: %.2f Food\nDemand: %.2f Food" % [
		profit, price, supply, demand
	]
