class_name Collectible
extends Node2D

@onready var animation_player: AnimationPlayer = $Collectible/AnimationPlayer
@onready var audio_stream_player: AudioStreamPlayer = $Collectible/AudioStreamPlayer

@export var collectible_type: CollectibleType

var picked_up = false

enum CollectibleType {INSTRUMENT, PROP}


func _ready() -> void:
	animation_player.play("idle")


func _on_collected(b):
	if picked_up: return
	
	picked_up = true
	Events.collectible_found.emit(int(collectible_type))
	animation_player.play("on_pickup")
	audio_stream_player.play()
	
	await animation_player.animation_finished
	queue_free()
