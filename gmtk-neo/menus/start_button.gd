extends Button

@export_file("*.tscn") var start_scene: String

@onready var hover_player: AudioStreamPlayer = get_parent().get_node("HoverPlayer")
@onready var click_player: AudioStreamPlayer = get_parent().get_node("ClickPlayer")

func _on_pressed() -> void:
	click_player.play()
	get_tree().change_scene_to_file(start_scene)


func _on_mouse_entered() -> void:
	hover_player.play()
