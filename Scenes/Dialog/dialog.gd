extends Panel

func _ready():
	visible = false
	$DialogButton.pressed.connect(close_box)

func show_box(text):
	$DialogLabel.text = text
	visible = true
	
func close_box():
	visible = false
	
