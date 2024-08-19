extends Area2D

signal is_active(is_active)

func _on_body_entered(body: Player) -> void:
	emit_signal("is_active", true)
