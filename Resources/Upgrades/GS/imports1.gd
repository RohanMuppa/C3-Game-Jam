extends UpgradeResource

func purchase_upgrade(game_main: GameMain, node: Node) -> void:
	upgrade_gs(game_main, node)

func upgrade_gs(game_main: GameMain, gs: GroceryStore) -> void:
	gs.income_bonus += 0.05
