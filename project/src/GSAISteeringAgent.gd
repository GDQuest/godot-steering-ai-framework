# Adds velocity, speed, and size data to `GSAIAgentLocation`.
#
# It is the character's responsibility to keep this information up to date for
# the steering toolkit to work correctly.
# category: Base types
extends GSAIAgentLocation
class_name GSAISteeringAgent

# The amount of velocity to be considered effectively not moving.
var zero_linear_speed_threshold := 0.01
# The maximum speed at which the agent can move.
var linear_speed_max := 0.0
# The maximum amount of acceleration that any behavior can apply to the agent.
var linear_acceleration_max := 0.0
# The maximum amount of angular speed at which the agent can rotate.
var angular_speed_max := 0.0
# The maximum amount of angular acceleration that any behavior can apply to an
# agent.
var angular_acceleration_max := 0.0
# Current velocity of the agent.
var linear_velocity := Vector3.ZERO
# Current angular velocity of the agent.
var angular_velocity := 0.0
# The radius of the sphere that approximates the agent's size in space.
var bounding_radius := 0.0
# Used internally by group behaviors and proximities to mark the agent as already
# considered.
var is_tagged := false
