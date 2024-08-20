class_name GameManager 
extends Node2D

@export var pause_menu: CanvasLayer

var _game_paused = false

@onready var player = $Player
@onready var spawn_point = $SpawnPoint

const MIN_DB = -20.0
const MAX_DB = 20.0

var stage = 0


func _ready() -> void:
	Events.toggle_pause_requested.connect(_toggle_paused_game)
	Events.on_restart_game.connect(_on_restart_game)
	Events.on_exit_game.connect(_on_exit_game)


func _toggle_paused_game():
	_game_paused = !_game_paused
	get_tree().paused = _game_paused
	
	if _game_paused:
		Engine.time_scale = 0
		pause_menu.show()
	else:
		Engine.time_scale = 1
		pause_menu.hide()


func _on_restart_game():
	_game_paused = false
	get_tree().paused = false
	Engine.time_scale = 1
	pause_menu.hide()
	
	player.global_position = spawn_point.global_position


func _on_volume_changed(value):
	var normalized_value = value / 100.0
	
	var db_value
	if normalized_value >= 0.5:
		var segment_normalized_value = (normalized_value - 0.5) / 0.5
		db_value = lerp(0.0, MAX_DB, segment_normalized_value)
	else: 
		var segment_normalized_value = normalized_value / 0.5
		db_value = lerp(MIN_DB, 0.0, segment_normalized_value)
	
	AudioServer.set_bus_volume_db(0, db_value)


func _on_exit_game():
	get_tree().quit()


# Called from portal
func on_goal_reached(c):
	player.global_position = spawn_point.global_position
	stage += 1
	player.set_morph(stage)
