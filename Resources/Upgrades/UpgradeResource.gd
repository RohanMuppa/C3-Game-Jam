@abstract
class_name UpgradeResource extends Resource

@abstract
func purchase_upgrade(game_main: GameMain, node: Node) -> void

func upgrade_gs(game_main: GameMain, gs: GroceryStore) -> void:
	pass

func upgrade_dp(game_main: GameMain, dp: DistributionPoint) -> void:
	pass
