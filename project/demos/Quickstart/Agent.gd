extends KinematicBody2D


export var maximum_speed := 450.0 # Maximum possible linear velocity
export var maximum_acceleration := 50.0 # Maximum change in linear velocity
export var maximum_rotation_speed := 240 # Maximum rotation velocity represented in degrees
export var maximum_rotation_accel := 40 # Maximum change in rotation velocity represented in degrees
export var maximum_health := 100
export var flee_health_threshold := 20

var velocity := Vector2.ZERO # Represents the current velocity
var angular_velocity := 0.0 # Represents the current rotational velocity
var acceleration := GSTTargetAcceleration.new() # Holds the linear and angular components
# calculated by our steering behaviors

onready var current_health := maximum_health

# GSTSteeringAgent holds our agent's position, orientation, maximum speed and acceleration
onready var agent := GSTSteeringAgent.new()

onready var player: Node = get_tree().get_nodes_in_group("Player")[0]
onready var player_agent: GSTSteeringAgent = player.agent # This assumes that our player class will
# keep its own agent updated

# Proximities represent an area with which an agent can identify where neighbors in its relevant
# group are. In our case, the group will feature the player, which will be used to avoid a
# collision with him. We use a radius proximity so the player is only relevant inside 100 pixels
onready var proximity := GSTRadiusProximity.new(agent, [player_agent], 100)

# GSTBlend combines behaviors together, calculating all of their acceleration together and adding
# them together, multiplied by a strength. We will have one for fleeing, and one for pursuing,
# toggling them depending on the agent's health. Since we want the agent to rotate AND move, then
# we aim to blend them together.
onready var flee_blend := GSTBlend.new(agent)
onready var pursue_blend := GSTBlend.new(agent)

# GSTPriority will be the main steering behavior we use. It holds sub-behaviors and will pick the  
# first one that returns non-zero acceleration, ignoring any afterwards.
onready var priority := GSTPriority.new(agent)


func _ready() -> void:
	# ---------- Configuration for our agent ----------
	agent.max_linear_speed = maximum_speed
	agent.max_linear_acceleration = maximum_acceleration
	agent.max_angular_speed = deg2rad(maximum_rotation_speed)
	agent.max_angular_acceleration = deg2rad(maximum_rotation_accel)
	agent.bounding_radius = calculate_radius($CollisionPolygon2D.polygon)
	update_agent()

	# ---------- Configuration for our behaviors ----------
	# Pursue will happen while the player is in good health. It produces acceleration that takes
	# the agent on an intercept course with the target, predicting its position in the future
	var pursue := GSTPursue.new(agent, player_agent)
	pursue.max_predict_time = 1.5

	# Flee will happen while the player is in bad health, so will start disabled. It produces
	# acceleration that takes the agent directly away from the target with no prediction.
	var flee := GSTFlee.new(agent, player_agent)

	# AvoidCollision tries to keep the agent from running into any of the neighbors found in its
	# proximity group. In this case, that will be the player, if he is close enough.
	var avoid := GSTAvoidCollisions.new(agent, proximity)

	# Face turns the agent to keep looking towards its target. It will be enabled while the agent
	# is not fleeing due to low health. It tries to arrive 'on alignment' with 0 remaining velocity
	var face := GSTFace.new(agent, player_agent)
	# We use deg2rad because the math in the toolkit assumes radians.
	face.alignment_tolerance = deg2rad(5) # How close for the agent to be 'aligned', if not exact
	face.deceleration_radius = deg2rad(45) # When to start slowing down

	# LookWhereYouGo turns the agent to keep looking towards its direction of travel. It will only
	# be enabled while the agent is at low health.
	var look := GSTLookWhereYouGo.new(agent)
	look.alignment_tolerance = deg2rad(5) # How close for the agent to be 'aligned', if not exact
	look.deceleration_radius = deg2rad(45) # When to start slowing down

	flee_blend.enabled = false # Behaviors that are not enabled produce 0 acceleration
	# Adding our fleeing behaviors to a blend. The order does not matter.
	flee_blend.add(look, 1)
	flee_blend.add(flee, 1)

	# Adding our pursuit behaviors to a blend. The order does not matter.
	pursue_blend.add(face, 1)
	pursue_blend.add(pursue, 1)

	# Adding our final behaviors to the main priority behavior. The order does matter.
	# We want to avoid collision with the player first, flee from the player second when enabled,
	# and pursue the player last when enabled.
	priority.add(avoid)
	priority.add(flee_blend)
	priority.add(pursue_blend)


func _physics_process(delta: float) -> void:
	update_agent() # Make sure any change in position and speed has been recorded

	if current_health <= flee_health_threshold: # Check to see if we should start fleeing or not
		pursue_blend.enabled = false
		flee_blend.enabled = true

	priority.calculate_steering(acceleration) # Calculate the desired acceleration

	# We add the discovered acceleration to our linear velocity. The toolkit does not limit
	# velocity, just acceleration, so we clamp the result ourselves here.
	velocity = (velocity + Vector2(
					acceleration.linear.x, acceleration.linear.y)
			).clamped(agent.max_linear_speed)
	# This applies drag on the agent's motion, helping it slow down naturally
	velocity = velocity.linear_interpolate(Vector2.ZERO, 0.1)
	# And since we're using a KinematicBody2D, we use Godot's excellent move_and_slide to actually
	# apply the final movement, and record any change in velocity the physics engine discovered
	velocity = move_and_slide(velocity)

	# We then do something similar to apply our agent's rotational speed
	angular_velocity = clamp(
			angular_velocity + acceleration.angular,
			-agent.max_angular_speed,
			agent.max_angular_speed
	)
	# This applies drag on the agent's rotation, helping it slow down naturally
	angular_velocity = lerp(angular_velocity, 0, 0.1)
	rotation += angular_velocity * delta


# In order to support both 2D and 3D, the toolkit uses Vector3, so the conversion is required
# when using 2D nodes. The Z component can be left to 0 safely.
func update_agent() -> void:
	agent.position.x = global_position.x
	agent.position.y = global_position.y
	agent.orientation = rotation
	agent.linear_velocity.x = velocity.x
	agent.linear_velocity.y = velocity.y
	agent.angular_velocity = angular_velocity


# We calculate the radius from the collision shape - this will approximate the agent's size in the
# game world, to avoid collisions with the player.
func calculate_radius(polygon: PoolVector2Array) -> float:
	var furthest_point := Vector2(-INF, -INF)
	for p in polygon:
		if abs(p.x) > furthest_point.x:
			furthest_point.x = p.x
		if abs(p.y) > furthest_point.y:
			furthest_point.y = p.y
	return furthest_point.length()


func damage(amount: int) -> void:
	current_health -= amount
	if current_health <= 0:
		queue_free()
