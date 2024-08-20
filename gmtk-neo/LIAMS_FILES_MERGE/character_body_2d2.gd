extends CharacterBody2D

@export var hook : GrapplingHook

@onready var collision = $CollisionShape2D
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

var large_sprite = preload("res://Player.png")
var medium_sprite = preload("res://PlayerMedium.png")
var small_sprite = preload("res://PlayerSmall.png")
var mini_sprite = preload("res://PlayerMicro.png")

var direction = Input.get_axis("walk_left", "walk_right")

func _physics_process(delta: float) -> void:
	# Add the gravity.
	if not is_on_floor():
		velocity.y += custom_grav * delta
	else:
		animationState.travel("Idle")
	# Handle jump.
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	direction = Input.get_axis("walk_left", "walk_right")
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
	print(global_position.y)
	if Input.is_action_just_pressed("1"):
		sprite.texture = large_sprite
		collision.shape.radius = 13
		collision.shape.height = 28
		camera.zoom = Vector2(3, 3)
		hook.chain_pull = hook.CHAIN_PULL
		hook.speed = hook.SPEED
		hook.range = hook.RANGE
		hook.scale = Vector2(1, 1)
		speed = SPEED
		acceleration = ACCELERATION
		deceleration = DECELERATION
		jump_velocity = JUMP_VELOCITY
		custom_grav = CUSTOM_GRAV
	if Input.is_action_just_pressed("2"):
		sprite.texture = medium_sprite
		collision.shape.radius = 6
		collision.shape.height = 14
		camera.zoom = Vector2(5, 5)
		hook.chain_pull = hook.CHAIN_PULL * 0.5
		hook.speed = hook.SPEED * 0.5
		hook.range = 60
		hook.scale = Vector2(1, 1) * 0.5
		speed = 45
		acceleration = ACCELERATION * 0.5
		deceleration = DECELERATION * 0.5
		jump_velocity = JUMP_VELOCITY * 0.6
		custom_grav = CUSTOM_GRAV * 0.5
	if Input.is_action_just_pressed("3"):
		sprite.texture = small_sprite
		collision.shape.radius = 7
		collision.shape.height = 7
		camera.zoom = Vector2(8, 8)
		hook.chain_pull = hook.CHAIN_PULL * 0.30
		hook.speed = hook.SPEED * 0.25
		hook.range = 60
		hook.scale = Vector2(1, 1) * 0.25
		speed = 35
		acceleration = ACCELERATION * 0.30
		deceleration = DECELERATION * 0.25
		jump_velocity = JUMP_VELOCITY * 0.30
		custom_grav = CUSTOM_GRAV * 0.25

#	scale = Vector2(1, 1) * modifier
