extends Button

@onready var about_window: Popup = $AboutWindow
@onready var hover_player: AudioStreamPlayer = get_parent().get_node("HoverPlayer")
@onready var click_player: AudioStreamPlayer = get_parent().get_node("ClickPlayer")


func _on_pressed() -> void:
	click_player.play()
	about_window.popup()


func _on_mouse_entered() -> void:
	hover_player.play()
