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
	if Input.is_action_just_pressed("1"):
		change_size(1)
		sprite.texture = large_sprite
		collision.shape.radius = 13
		collision.shape.height = 28
		camera.zoom = Vector2(4, 4)
	if Input.is_action_just_pressed("2"):
		change_size(0.5)
		sprite.texture = medium_sprite
		collision.shape.radius = 6
		collision.shape.height = 14
		camera.zoom = Vector2(6, 6)
	if Input.is_action_just_pressed("3"):
		change_size(0.25)
		sprite.texture = small_sprite
		collision.shape.radius = 7
		collision.shape.height = 7
		camera.zoom = Vector2(8, 8)
	if Input.is_action_just_pressed("4"):
		change_size(0.125)
		sprite.texture = mini_sprite
		collision.shape.radius = 1.5
		collision.shape.height = 3.5
		camera.zoom = Vector2(10, 10)
	
func change_size(modifier):
	hook.chain_pull = hook.CHAIN_PULL * modifier
	hook.speed = hook.SPEED * (modifier * 2)
	hook.range = hook.RANGE * modifier
	hook.scale = Vector2(1, 1) * modifier
	speed = SPEED * modifier
	acceleration = ACCELERATION * modifier
	deceleration = DECELERATION * modifier
	jump_velocity = JUMP_VELOCITY * modifier
	custom_grav = CUSTOM_GRAV * modifier
#	scale = Vector2(1, 1) * modifier
