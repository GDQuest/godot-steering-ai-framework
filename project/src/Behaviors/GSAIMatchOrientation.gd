# Calculates an angular acceleration to match an agent's orientation to that of
# its target. Attempts to make the agent arrive with zero remaining angular
# velocity.
# category: Individual behaviors
class_name GSAIMatchOrientation
extends GSAISteeringBehavior

# The target orientation for the behavior to try and match rotations to.
var target: GSAIAgentLocation
# The amount of distance in radians for the behavior to consider itself close
# enough to be matching the target agent's rotation.
var alignment_tolerance: float
# The amount of distance in radians from the goal to start slowing down.
var deceleration_radius: float
# The amount of time to reach the target velocity
var time_to_reach: float = 0.1
# Whether to use the X and Z components instead of X and Y components when
# determining angles. X and Z should be used in 3D.
var use_z: bool


func _init(agent: GSAISteeringAgent, _target: GSAIAgentLocation, _use_z := false).(agent) -> void:
	self.use_z = _use_z
	self.target = _target


func _match_orientation(acceleration: GSAITargetAcceleration, desired_orientation: float) -> void:
	var rotation := wrapf(desired_orientation - agent.orientation, -PI, PI)

	var rotation_size := abs(rotation)

	if rotation_size <= alignment_tolerance:
		acceleration.set_zero()
	else:
		var desired_rotation := agent.angular_speed_max

		if rotation_size <= deceleration_radius:
			desired_rotation *= rotation_size / deceleration_radius

		desired_rotation *= rotation / rotation_size

		acceleration.angular = ((desired_rotation - agent.angular_velocity) / time_to_reach)

		var limited_acceleration := abs(acceleration.angular)
		if limited_acceleration > agent.angular_acceleration_max:
			acceleration.angular *= (agent.angular_acceleration_max / limited_acceleration)

	acceleration.linear = Vector3.ZERO


func _calculate_steering(acceleration: GSAITargetAcceleration) -> void:
	_match_orientation(acceleration, target.orientation)
