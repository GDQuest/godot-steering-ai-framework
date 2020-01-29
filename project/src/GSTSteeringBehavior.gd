# Base class for all steering behaviors.
#
# Steering behaviors calculate the linear and the angular acceleration to be
# to the agent that owns them.
#
# The `calculate_steering` function is the entry point for all behaviors.
# Individual steering behaviors encapsulate the steering logic.
class_name GSTSteeringBehavior


# If `false`, all calculations return zero amounts of acceleration.
var is_enabled := true
# The AI agent on which the steering behavior bases its calculations.
var agent: GSTSteeringAgent


func _init(agent: GSTSteeringAgent) -> void:
	self.agent = agent


# Returns the `acceleration` modified with the behavior's desired amount of
# acceleration.
func calculate_steering(acceleration: GSTTargetAcceleration) -> GSTTargetAcceleration:
	if is_enabled:
		return _calculate_steering(acceleration)
	else:
		acceleration.set_zero()
		return acceleration


func _calculate_steering(acceleration: GSTTargetAcceleration) -> GSTTargetAcceleration:
	acceleration.set_zero()
	return acceleration
