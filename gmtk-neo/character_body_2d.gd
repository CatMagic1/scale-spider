extends CharacterBody2D

@onready var camera = $Camera2D
@onready var sprite = $Sprite2D
@onready var animationPlayer = $AnimationPlayer
@onready var animationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")

const SPEED = 100.0
const ACCELERATION = 10.0
const DECELERATION = 5.0
const JUMP_VELOCITY = -170.0
const CUSTOM_GRAV = 490

var speed = SPEED
var acceleration = ACCELERATION
var deceleration = DECELERATION
var jump_velocity = JUMP_VELOCITY
var custom_grav = CUSTOM_GRAV

@onready var stream: AudioStreamSynchronized = $Music.stream


func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity += get_gravity() * delta
	else:
		animationState.travel("Idle")
	# Handle jump.
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var direction := Input.get_axis("walk_left", "walk_right")
	if direction:
		velocity.x = move_toward(velocity.x, direction * speed, acceleration)
		if is_on_floor():
			animationState.travel("Walk")
		if direction > 0:
			sprite.flip_h = false
		else:
			sprite.flip_h = true
	else:
		velocity.x = move_toward(velocity.x, 0, deceleration)
		if is_on_floor():
			animationState.travel("Idle")

	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
		animationState.travel("Jump")

	move_and_slide()


func _process(delta):
	if Input.is_action_just_pressed("1"):
		change_size(1)
		stream.set_sync_stream_volume(0, 0)
		stream.set_sync_stream_volume(1, -INF)
		stream.set_sync_stream_volume(2, -INF)
		stream.set_sync_stream_volume(3, -INF)
	if Input.is_action_just_pressed("2"):
		change_size(0.5)
		stream.set_sync_stream_volume(0, 0)
		stream.set_sync_stream_volume(1, 0)
		stream.set_sync_stream_volume(2, -INF)
		stream.set_sync_stream_volume(3, -INF)
	if Input.is_action_just_pressed("3"):
		change_size(0.25)
		stream.set_sync_stream_volume(0, 0)
		stream.set_sync_stream_volume(1, 0)
		stream.set_sync_stream_volume(2, 0)
		stream.set_sync_stream_volume(3, -INF)
	if Input.is_action_just_pressed("4"):
		change_size(0.125)
		stream.set_sync_stream_volume(0, 0)
		stream.set_sync_stream_volume(1, 0)
		stream.set_sync_stream_volume(2, 0)
		stream.set_sync_stream_volume(3, 0)



func change_size(modifier):
	speed = SPEED * modifier
	acceleration = ACCELERATION * modifier
	deceleration = DECELERATION * modifier
	jump_velocity = JUMP_VELOCITY
	scale = Vector2(1, 1) * modifier
	camera.zoom = Vector2(4, 4) / (modifier * 1.5)
	custom_grav = CUSTOM_GRAV * modifier
