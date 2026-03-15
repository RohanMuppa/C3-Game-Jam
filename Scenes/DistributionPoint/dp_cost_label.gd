extends Label

func _process(delta: float) -> void:
	text = "$%.2f" %[get_tree().get_nodes_in_group("DP_Preview")[0].cost]
	
