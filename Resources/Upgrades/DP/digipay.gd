extends UpgradeResource

static var sent_msg = false


func purchase_upgrade(game_main: GameMain, node: Node) -> void:
	upgrade_dp(game_main, node)

func upgrade_dp(game_main: GameMain, dp: DistributionPoint) -> void:
	dp.resilience_score *= 1.25
	if (!sent_msg):
		var arr: Array[CustomText] = [
			CustomText.create("Emilija: As much as I like cash, this has truly made things easier—and quicker too! ", 10)
		]
		game_main.dialog_box.set_text(arr)
		sent_msg = true
