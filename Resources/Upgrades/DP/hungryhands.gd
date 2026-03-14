extends UpgradeResource

func purchase_upgrade(game_main: GameMain, node: Node) -> void:
	upgrade_dp(game_main, node)

func upgrade_dp(game_main: GameMain, dp: DistributionPoint) -> void:
	dp.house_consumption += 1
