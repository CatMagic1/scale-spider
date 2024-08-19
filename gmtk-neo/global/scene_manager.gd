extends CanvasLayer

@onready var world_environment: WorldEnvironment = $WorldEnvironment
@onready var change_sound: AudioStreamPlayer = $ChangeSound
@onready var animation: AnimationPlayer = $AnimationPlayer
@onready var timer: Timer = $Timer

enum ControlType {
	Change,
	Restart,
	Exit
}

var current_scene: Node
var scene_path: String
var control_type := ControlType.Change
var animation_name := "fade"
var animation_speed := 1

func _ready() -> void:
	current_scene = get_tree().root.get_child(-1)

func restart() -> void:
	control_type = ControlType.Restart
	animation_speed = 2
	change_sound.play()
	scene_control()

func respawn() -> void:
	control_type = ControlType.Restart
	animation_speed = 2
	scene_control()

func change(path: String) -> void:
	scene_path = path
	control_type = ControlType.Change
	animation_speed = 1
	change_sound.play()
	scene_control()

func exit() -> void:
	control_type = ControlType.Exit
	animation_speed = 1
	scene_control()

func scene_control() -> void:
	timer.stop()
	get_tree().paused = true
	animation.set_speed_scale(animation_speed)
	animation.play(animation_name)
	timer.start()

func deferred_change_scene_to_file(_scene_path: String) -> void:
	current_scene.free()
	current_scene = load(_scene_path).instantiate()
	get_tree().root.add_child.call_deferred(current_scene)
	get_tree().current_scene = current_scene

func _on_timer_timeout() -> void:
	match control_type:
		ControlType.Change:
			assert(get_tree().change_scene_to_file(scene_path) == OK)
		ControlType.Restart:
			assert(get_tree().reload_current_scene() == OK)
		ControlType.Exit:
			get_tree().quit()
	animation.play_backwards(animation_name)
	get_tree().paused = false
