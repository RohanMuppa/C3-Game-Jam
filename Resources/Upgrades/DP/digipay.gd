extends UpgradeResource

static var sent_msg = false


func purchase_upgrade(game_main: GameMain, node: Node) -> void:
	upgrade_dp(game_main, node)

func upgrade_dp(game_main: GameMain, dp: DistributionPoint) -> void:
	dp.resilience_score *= 1.25
	if (!sent_msg):
		var arr: Array[CustomText] = [
			CustomText.create("Emilija: Farmer Zemnieks, it’s been a while! I’ve brought Andris this week to help carry such large orders. How is everything?", 10),
			CustomText.create("Farmer Zemnieks: Business has gotten slower, but thanks to ya regulars, I’ve been able to get by.", 10),
			CustomText.create("Emilija: We’ll always be here to support. Besides how could we give up such good tomatoes?", 10)
		]
		game_main.dialog_box.set_text(arr)
		sent_msg = true
