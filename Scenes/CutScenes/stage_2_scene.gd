extends Node2D

func _ready() -> void:
	$s2Animation.animation_finished.connect(_on_AnimationPlayer_animation_finished)
	$s2Animation.play("stage2Scene")
	
func _on_AnimationPlayer_animation_finished(anim_name: String) -> void:
	if anim_name == "stage2Scene":
		var main_scene = preload("res://Main.tscn")
		get_tree().change_scene_to_packed(main_scene)
