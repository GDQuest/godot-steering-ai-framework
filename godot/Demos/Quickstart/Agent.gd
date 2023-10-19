extends CharacterBody2D

# Maximum possible linear velocity
@export var speed_max := 450.0
# Maximum change in linear velocity
@export var acceleration_max := 50.0
# Maximum rotation velocity represented in degrees
@export var angular_speed_max := 240
# Maximum change in rotation velocity represented in degrees
@export var angular_acceleration_max := 40

@export var health_max := 100
@export var flee_health_threshold := 20

var angular_velocity := 0.0
var linear_drag := 0.1
var angular_drag := 0.1

# Holds the linear and angular components calculated by our steering behaviors.
var acceleration := GSAITargetAcceleration.new()

@onready var current_health := health_max

# GSAISteeringAgent holds our agent's position, orientation, maximum speed and acceleration.
@onready var agent := GSAISteeringAgent.new()

@onready var player: Node = get_tree().get_nodes_in_group("Player")[0]
# This assumes that our player class will keep its own agent updated.
@onready var player_agent: GSAISteeringAgent = player.agent

# Proximities represent an area with which an agent can identify where neighbors in its relevant
# group are. In our case, the group will feature the player, which will be used to avoid a
# collision with them. We use a radius proximity so the player is only relevant inside 100 pixels.
@onready var proximity := GSAIRadiusProximity.new(agent, [player_agent], 100)

# GSAIBlend combines behaviors together, calculating all of their acceleration together and adding
# them together, multiplied by a strength. We will have one for fleeing, and one for pursuing,
# toggling them depending on the agent's health. Since we want the agent to rotate AND move, then
# we aim to blend them together.
@onready var flee_blend := GSAIBlend.new(agent)
@onready var pursue_blend := GSAIBlend.new(agent)

# GSAIPriority will be the main steering behavior we use. It holds sub-behaviors and will pick the
# first one that returns non-zero acceleration, ignoring any afterwards.
@onready var priority := GSAIPriority.new(agent)


func _ready() -> void:
	# ---------- Configuration for our agent ----------
	agent.linear_speed_max = speed_max
	agent.linear_acceleration_max = acceleration_max
	agent.angular_speed_max = deg_to_rad(angular_speed_max)
	agent.angular_acceleration_max = deg_to_rad(angular_acceleration_max)
	agent.bounding_radius = calculate_radius($CollisionPolygon2D.polygon)
	update_agent()

	# ---------- Configuration for our behaviors ----------
	# Pursue will happen while the agent is in good health. It produces acceleration that takes
	# the agent on an intercept course with the target, predicting its position in the future.
	var pursue := GSAIPursue.new(agent, player_agent)
	pursue.predict_time_max = 1.5

	# Flee will happen while the agent is in bad health, so will start disabled. It produces
	# acceleration that takes the agent directly away from the target with no prediction.
	var flee := GSAIFlee.new(agent, player_agent)

	# AvoidCollision tries to keep the agent from running into any of the neighbors found in its
	# proximity group. In our case, this will be the player, if they are close enough.
	var avoid := GSAIAvoidCollisions.new(agent, proximity)

	# Face turns the agent to keep looking towards its target. It will be enabled while the agent
	# is not fleeing due to low health. It tries to arrive 'on alignment' with 0 remaining velocity.
	var face := GSAIFace.new(agent, player_agent)

	# We use deg2rad because the math in the toolkit assumes radians.
	# How close for the agent to be 'aligned', if not exact.
	face.alignment_tolerance = deg_to_rad(5)
	# When to start slowing down
	face.deceleration_radius = deg_to_rad(60)

	# LookWhereYouGo turns the agent to keep looking towards its direction of travel. It will only
	# be enabled while the agent is at low health.
	var look := GSAILookWhereYouGo.new(agent)
	# How close for the agent to be 'aligned', if not exact
	look.alignment_tolerance = deg_to_rad(5)
	# When to start slowing down.
	look.deceleration_radius = deg_to_rad(60)

	# Behaviors that are not enabled produce 0 acceleration.
	# Adding our fleeing behaviors to a blend. The order does not matter.
	flee_blend.is_enabled = false
	flee_blend.add(look, 1)
	flee_blend.add(flee, 1)

	# Adding our pursuit behaviors to a blend. The order does not matter.
	pursue_blend.add(face, 1)
	pursue_blend.add(pursue, 1)

	# Adding our final behaviors to the main priority behavior. The order does matter here.
	# We want to avoid collision with the player first, flee from the player second when enabled,
	# and pursue the player last when enabled.
	priority.add(avoid)
	priority.add(flee_blend)
	priority.add(pursue_blend)


func _physics_process(delta: float) -> void:
	# Make sure any change in position and speed has been recorded.
	update_agent()

	if current_health <= flee_health_threshold:
		pursue_blend.is_enabled = false
		flee_blend.is_enabled = true

	# Calculate the desired acceleration.
	priority.calculate_steering(acceleration)

	# We add the discovered acceleration to our linear velocity. The toolkit does not limit
	# velocity, just acceleration, so we clamp the result ourselves here.
	velocity = (velocity + Vector2(acceleration.linear.x, acceleration.linear.y) * delta).limit_length(
		agent.linear_speed_max
	)

	# This applies drag on the agent's motion, helping it to slow down naturally.
	velocity = velocity.lerp(Vector2.ZERO, linear_drag)

	# And since we're using a KinematicBody2D, we use Godot's excellent move_and_slide to actually
	# apply the final movement, and record any change in velocity the physics engine discovered.
	move_and_slide()

	# We then do something similar to apply our agent's rotational speed.
	angular_velocity = clamp(
		angular_velocity + acceleration.angular * delta, -agent.angular_speed_max, agent.angular_speed_max
	)
	# This applies drag on the agent's rotation, helping it slow down naturally.
	angular_velocity = lerp(angular_velocity, 0.0, angular_drag)
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
func calculate_radius(polygon: PackedVector2Array) -> float:
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
