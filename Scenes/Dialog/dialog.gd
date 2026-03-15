extends Panel

var text: Array[CustomText] = []
var time_to_close: float = 0

func _ready():
	visible = false
	$DialogButton.pressed.connect(advance)

func _process(delta: float) -> void:
	if (time_to_close > 0):
		time_to_close -= delta
		return
	advance()

func set_text(text: Array[CustomText]):
	self.text = text
	advance()

func advance():
	if text.size() == 0:
		visible = false
		return
	var to_show: CustomText = text.pop_front()
	$DialogLabel.text = to_show.text
	time_to_close = to_show.timeout
	if to_show.icon:
		$TextureRect.texture = to_show.icon
		$TextureRect.visible = true
	else:
		$TextureRect.visible = false
	visible = true
	
	
