extends UpgradeResource

func purchase_upgrade(game_main: GameMain, node: Node) -> void:
	upgrade_gs(game_main, node)

func upgrade_gs(game_main: GameMain, gs: GroceryStore) -> void:
	gs.food_intake += 2
	gs.resilience_score /= 1.15
