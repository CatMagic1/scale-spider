class_name InputHandler
extends Node

var previous_mouse_position := Vector2.ZERO


func _ready():
	previous_mouse_position = get_viewport().get_mouse_position()


func _input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		if event.is_action_pressed("first_ability"):
			Events.ability_executed.emit(0)
		elif event.is_action_released("first_ability"):
			Events.ability_cancelled.emit(0)

		elif event.is_action_pressed("second_ability"):
			Events.ability_executed.emit(1)
		elif event.is_action_released("second_ability"):
			Events.ability_cancelled.emit(1)


func _process(delta: float) -> void:

	# Key input
	if Engine.time_scale == 1:

		if Input.is_action_just_pressed("first_ability"):
			Events.ability_executed.emit(0)
		elif Input.is_action_just_released("first_ability"):
			Events.ability_cancelled.emit(0)

		elif Input.is_action_just_pressed("second_ability"):
			Events.ability_executed.emit(1)
		elif Input.is_action_just_released("second_ability"):
			Events.ability_cancelled.emit(1)


	# Toggle pause
	if Input.is_action_just_pressed("Pause"):
		Events.toggle_pause_requested.emit()
