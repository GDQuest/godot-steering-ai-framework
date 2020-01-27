extends GSTAgentLocation
class_name GSTSteeringAgent
# An extended `GSTAgentLocation` that adds velocity, speed, and size data. It is the character's
# responsibility to keep this information up to date for the steering toolkit to work correctly.


# The amount of velocity to be considered effectively not moving.
var zero_linear_speed_threshold := 0.01
# The maximum amount of speed the agent can move at.
var linear_speed_max := 0.0
# The maximum amount of acceleration that any behavior can apply to an agent.
var linear_acceleration_max := 0.0
# The maximum amount of angular speed the agent can rotate at.
var angular_speed_max := 0.0
# The maximum amount of angular acceleration that any behavior can apply to an agent.
var angular_acceleration_max := 0.0
# The current speed in a given direction the agent is traveling at.
var linear_velocity := Vector3.ZERO
# The current angular speed the agent is traveling at.
var angular_velocity := 0.0
# The radius of the sphere that approximates the agent's size in space.
var bounding_radius := 0.0
# Used internally by group behaviors and proximities to mark an agent as already considered.
var tagged := false
