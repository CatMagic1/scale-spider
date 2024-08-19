extends CharacterBody2D
class_name Player

@onready var collision: CollisionShape2D = $CollisionShape2D
@onready var camera: Camera2D = $Camera2D
@onready var sprite: Sprite2D = $Sprite2D
@onready var animation_player: AnimationPlayer = $AnimationPlayer
@onready var animation_tree: AnimationTree = $AnimationTree
@onready var animation_state: AnimationNodeStateMachinePlayback = animation_tree.get("parameters/playback")
@onready var music_animation: AnimationPlayer = $MusicAnimation
@onready var stream: AudioStreamSynchronized = $Music.stream

var large_sprite := preload("res://art/player_big.png")
var medium_sprite := preload("res://art/player_medium.png")
var small_sprite := preload("res://art/player_small.png")
var mini_sprite := preload("res://art/player_micro.png")

@export var initial_speed := 100.0
@export var initial_acceleration := 10.0
@export var initial_decceleration := 10.0
@export var initial_jump_velocity := -200.0
@export var initial_gravity := 480.0

# Left to right
# Pivot - grappling
# Level design with what we have

# Big size - move fast
# Medium size -
# Small size - use grapple (pivots)
# Tiny size

var is_transforming := false
var speed := initial_speed
var acceleration := initial_acceleration
var deceleration := initial_decceleration
var jump_velocity := initial_jump_velocity
var custom_grav := initial_gravity


func _physics_process(delta: float) -> void:
	if is_transforming: return

	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		animation_state.travel("Idle")

	# Handle jump.
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("walk_left", "walk_right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * speed, acceleration)
		if is_on_floor():
			animation_state.travel("Walk")
		if direction > 0:
			sprite.flip_h = false
		else:
			sprite.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration)
		if is_on_floor():
			animation_state.travel("Idle")
			velocity.x = move_toward(velocity.x, 0, deceleration * 3)

	# Handle Jump
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		animation_state.travel("Jump")

	move_and_slide()


func _input(event: InputEvent) -> void:
	if is_transforming: return

	if event.is_action_pressed("1"):
		music_animation.play("4")
		sprite.texture = large_sprite
		collision.shape.radius = 13
		collision.shape.height = 28
		change_size(1)
	elif event.is_action_pressed("2"):
		music_animation.play("3")
		sprite.texture = medium_sprite
		collision.shape.radius = 6
		collision.shape.height = 14
		change_size(0.5)
	elif event.is_action_pressed("3"):
		music_animation.play("2")
		sprite.texture = small_sprite
		collision.shape.radius = 7
		collision.shape.height = 7
		change_size(0.25)
	elif event.is_action_pressed("4"):
		music_animation.play("1")
		sprite.texture = mini_sprite
		collision.shape.radius = 1.5
		collision.shape.height = 3.5
		change_size(0.125)


func change_size(modifier: float) -> void:
	Events.scale_changed.emit(modifier)
	var tween: Tween = get_tree().create_tween()
	speed = initial_speed / (modifier + 0.5)
	acceleration = initial_acceleration / modifier
	jump_velocity = initial_jump_velocity
	tween.tween_property(camera, "zoom", Vector2(4, 4) / (modifier), 1)
	custom_grav = initial_gravity * modifier
	animation_state.travel("transform")
	is_transforming = true


func _finished_transform():
	is_transforming = false
