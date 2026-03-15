extends Node2D

signal cutscene_finished

func _ready() -> void:
	visible = false
	$s2Animation.animation_finished.connect(_on_AnimationPlayer_animation_finished)
	
func play_scene():
	visible = true
	$s2Animation.play("stage2Scene")
	
func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "stage2Scene":
		visible = false
		emit_signal("cutscene_finished")
	
		
