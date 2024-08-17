extends Node2D

@onready var raycast = $RayCast2D
@onready var line = $Line2D

func _process(delta: float) -> void:
	if Input.is_action_just_pressed("ui_accept"):
		raycast.look_at(get_global_mouse_position())
		if raycast.is_colliding():
			line.points.append(raycast.get_collision_point())
			line.points.append(global_position)
