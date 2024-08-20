extends Node2D

# TODO: SET THIS TO START SCENE
@export_file("*.tscn") var start_scene: String

func _on_animation_player_animation_finished(anim_name: StringName) -> void:
	get_tree().change_scene_to_file(start_scene)
