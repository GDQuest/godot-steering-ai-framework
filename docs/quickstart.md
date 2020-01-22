# Godot Steering Toolkit #

In the 1990s, a man by the name of [Craig Reynolds](http://www.red3d.com/cwr/) developed algorithms for common AI behaviors. Those were tasks like seeking out or fleeing from a target, following a pre-defined path, or facing in a particular direction. They were simple, repeatable tasks that could be broken down into a programming algorithm, which made them easy to extend.

While an AI agent's decision of what to do is part of decision making and planning algorithms, steering behaviors answer the question of how to move right away at a frame-to-frame resolution.

Joined together, they can offer complex and graceful movement while being less expensive on performance than complex path finding algorithms like A\*, and are easier to re-use and maintain than populating a function full of if statements.

The use of pure and simple mathematics aims to answer the question "given the information I have, where and how fast do I move right this moment?"

## Summary ##

This toolkit is a framework for the [Godot engine](https://godotengine.org/). It takes a lot of inspiration from the excellent [GDX-AI](https://github.com/libgdx/gdx-ai) framework for the [LibGDX](https://libgdx.badlogicgames.com/) java-based framework. Every class in the toolkit is based on Godot's [Reference](https://docs.godotengine.org/en/latest/classes/class_reference.html) type. There is no need to have a complex scene tree; everything that has to do with the AI's movement can be contained inside movement oriented classes.

As a short overview, a character is represented by a steering agent; it stores its position, orientation, maximum speeds and current velocity. A steering behavior is associated with a steering agent and it calculates a linear and/or angular change in speed from the information that is available. The coder then applies that acceleration in whatever ways is appropriate to the character to change its velocity.

## More information and resources ##

- [Understanding Steering Behaviors](https://gamedevelopment.tutsplus.com/series/understanding-steering-behaviors--gamedev-12732): Breakdowns of various behaviors by Fernando Bevilacqua with graphics and in-depth explanations.
- [GDX-AI Wiki](https://github.com/libgdx/gdx-ai/wiki/Steering-Behaviors): Descriptions of how LibGDX's AI submodule uses steering behaviors with a few graphics. Since this toolkit uses it for inspiration, there will be some similarities.
- [RedBlobGames](https://www.redblobgames.com/) - An excellent resources for complex pathfinding like A*, graph theory, and other algorithms that are game-development related. Steering behaviors are not covered, but for anyone looking to study and bulk up on their algorithms, this is a great place.

## Example usage ##

The fastest way to get started is to look at an explained sample class that makes use of the toolkit.

The goal of this class is to represent an agent that chases the player and predicts where the player *will* be, but maintains a distance from him. When its health is low, it will flee from the player directly. The agent will keep facing the player while it is chasing it, but will look where it's going while it is fleeing. Our game will be in 2D, assumed to be a top-down spaceship game.

You can see the demo in action by opening the `demos/QuickStartDemo.tscn` file in Godot. The result is an agent that approaches the player and hovers near him until it is shot enough times, at which point it will try to flee directly.

More details about how the various steering behaviors function can be found in the [Reference](./reference.md) document.

```ruby
extends KinematicBody2D


# Maximum possible linear velocity
export var speed_max := 450.0
# Maximum change in linear velocity
export var acceleration_max := 50.0
# Maximum rotation velocity represented in degrees
export var angular_speed_max := 240
# Maximum change in rotation velocity represented in degrees
export var angular_acceleration_max := 40

export var health_max := 100
export var flee_health_threshold := 20

var velocity := Vector2.ZERO
var angular_velocity := 0.0
var linear_drag := 0.1
var angular_drag := 0.1

# Holds the linear and angular components calculated by our steering behaviors
var acceleration := GSTTargetAcceleration.new()

onready var current_health := health_max

# GSTSteeringAgent holds our agent's position, orientation, maximum speed and acceleration
onready var agent := GSTSteeringAgent.new()

onready var player: Node = get_tree().get_nodes_in_group("Player")[0]
# This assumes that our player class will keep its own agent updated
onready var player_agent: GSTSteeringAgent = player.agent

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
    agent.max_linear_speed = speed_max
    agent.max_linear_acceleration = acceleration_max
    agent.max_angular_speed = deg2rad(angular_speed_max)
    agent.max_angular_acceleration = deg2rad(angular_acceleration_max)
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
    # How close for the agent to be 'aligned', if not exact
    face.alignment_tolerance = deg2rad(5)
    # When to start slowing down
    face.deceleration_radius = deg2rad(45)

    # LookWhereYouGo turns the agent to keep looking towards its direction of travel. It will only
    # be enabled while the agent is at low health.
    var look := GSTLookWhereYouGo.new(agent)
    # How close for the agent to be 'aligned', if not exact
    look.alignment_tolerance = deg2rad(5)
    # When to start slowing down
    look.deceleration_radius = deg2rad(45)

    # Behaviors that are not enabled produce 0 acceleration
    # Adding our fleeing behaviors to a blend. The order does not matter.
    flee_blend.enabled = false
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
    # Make sure any change in position and speed has been recorded
    update_agent()

    if current_health <= flee_health_threshold:
        pursue_blend.enabled = false
        flee_blend.enabled = true

    # Calculate the desired acceleration
    priority.calculate_steering(acceleration)

    # We add the discovered acceleration to our linear velocity. The toolkit does not limit
    # velocity, just acceleration, so we clamp the result ourselves here.
    velocity = (velocity + Vector2(
                    acceleration.linear.x, acceleration.linear.y)
    ).clamped(agent.max_linear_speed)

    # This applies drag on the agent's motion, helping it slow down naturally
    velocity = velocity.linear_interpolate(Vector2.ZERO, linear_drag)

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
    angular_velocity = lerp(angular_velocity, 0, angular_drag)
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

```
