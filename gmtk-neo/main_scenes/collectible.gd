class_name collectible
extends Sprite2D

@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var audio_stream_player: AudioStreamPlayer = $AudioStreamPlayer

@export var collectible_type: CollectibleType


enum CollectibleType {INSTRUMENT, PROP}

func _on_collected(b):
	set_physics_process(false)
	Events.collectible_found.emit(int(collectible_type))
	animation_player.play("on_pickup")
	audio_stream_player.play()
