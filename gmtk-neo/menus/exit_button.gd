extends Button

@onready var hover_player: AudioStreamPlayer = get_parent().get_node("HoverPlayer")
@onready var click_player: AudioStreamPlayer = get_parent().get_node("ClickPlayer")


func _on_pressed() -> void:
	click_player.play()
	get_tree().quit()


func _on_mouse_entered() -> void:
	hover_player.play()
