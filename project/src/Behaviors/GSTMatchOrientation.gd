class_name GSTMatchOrientation
extends GSTSteeringBehavior
# Calculates an angular acceleration to match an agent's orientation to its target's.
# The calculation will attempt to arrive with zero remaining angular velocity.


# The target orientation for the behavior to try and match rotations to
var target: GSTAgentLocation
# The amount of distance in radians for the behavior to consider itself close enough to match
var alignment_tolerance: float
# The amount of distance in radians from the goal to start slowing down
var deceleration_radius: float
# A constant to represent the time it takes to change angular accelerations
var time_to_reach: float = 0.1


# Initializes the behavior
func _init(agent: GSTSteeringAgent, target: GSTAgentLocation).(agent) -> void:
	self.target = target


func _match_orientation(acceleration: GSTTargetAcceleration, desired_orientation: float) -> GSTTargetAcceleration:
	var rotation := wrapf(desired_orientation - agent.orientation, -PI, PI)

	var rotation_size := abs(rotation)

	if rotation_size <= alignment_tolerance:
		acceleration.set_zero()
	else:
		var desired_rotation := agent.angular_speed_max
	
		if rotation_size <= deceleration_radius:
			desired_rotation *= rotation_size / deceleration_radius
		
		desired_rotation *= rotation / rotation_size
	
		acceleration.angular = (desired_rotation - agent.angular_velocity) / time_to_reach
	
		var limited_acceleration := abs(acceleration.angular)
		if limited_acceleration > agent.angular_acceleration_max:
			acceleration.angular *= agent.angular_acceleration_max / limited_acceleration
	
	acceleration.linear = Vector3.ZERO
	
	return acceleration


func _calculate_steering(acceleration: GSTTargetAcceleration) -> GSTTargetAcceleration:
	return _match_orientation(acceleration, target.orientation)
