class_name GrapplingHook
extends Ability

@onready var links = $Links		# A slightly easier reference to the links

var direction := Vector2(0,0)	# The direction in which the chain was shot
var tip := Vector2(0,0)			# The global position the tip should be in
								# We use an extra var for this, because the chain is
								# connected to the player and thus all .position
								# properties would get messed with when the player
								# moves.

const SPEED = 50	# The speed with which the chain moves
const CHAIN_PULL = 30

var flying = false	# Whether the chain is moving through the air
var hooked = false	# Whether the chain has connected to a wall

var chain_velocity := Vector2(0,0)
var parent: CharacterBody2D


func _ready() -> void:
	Events.ability_executed.connect(shoot)
	Events.ability_cancelled.connect(release)

	parent = get_parent()


# shoot() shoots the chain in a given direction
func shoot(idx) -> void:
	if idx != 1: return

	var mouse_pos = get_global_mouse_position() - get_parent().global_position
	direction = mouse_pos.normalized()	# Normalize the direction and save it
	flying = true					# Keep track of our current scan
	tip = parent.global_position		# reset the tip position to the player's position


# release() the chain
func release(idx) -> void:
	flying = false	# Not flying anymore
	hooked = false	# Not attached anymore


# Every graphics frame we update the visuals
func _process(_delta: float) -> void:
	self.visible = flying or hooked	# Only visible if flying or attached to something
	if not self.visible:
		return	# Not visible -> nothing to draw
	var tip_loc = to_local(tip)	# Easier to work in local coordinates
	# We rotate the links (= chain) and the tip to fit on the line between self.position (= origin = player.position) and the tip
	links.rotation = parent.position.angle_to_point(tip_loc) - deg_to_rad(90)
	$Tip.rotation = parent.position.angle_to_point(tip_loc) - deg_to_rad(90)
	links.position = tip_loc						# The links are moved to start at the tip
	links.region_rect.size.y = tip_loc.length()		# and get extended for the distance between (0,0) and the tip


# Every physics frame we update the tip position
func _physics_process(_delta: float) -> void:
	$Tip.global_position = tip	# The player might have moved and thus updated the position of the tip -> reset it
	if flying:
		# `if move_and_collide()` always moves, but returns true if we did collide
		if $Tip.move_and_collide(direction * SPEED):
			hooked = true	# Got something!
			flying = false	# Not flying anymore
	tip = $Tip.global_position	# set `tip` as starting position for next frame

	if hooked:
		# `to_local($Chain.tip).normalized()` is the direction that the chain is pulling
		chain_velocity = to_local(tip).normalized() * CHAIN_PULL
		if chain_velocity.y > 0:
			# Pulling down isn't as strong
			chain_velocity.y *= 0.55
		else:
			# Pulling up is stronger
			chain_velocity.y *= 1.65
		if sign(chain_velocity.x) != sign(parent.velocity.x):
			# if we are trying to walk in a different
			# direction than the chain is pulling
			# reduce its pull
			chain_velocity.x *= 0.7
	else:
		# Not hooked -> no chain velocity
		chain_velocity = Vector2(0,0)
	parent.velocity += chain_velocity
