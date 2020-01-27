class_name GSTSteeringBehavior
# The base class for all steering behaviors to extend. A steering behavior calculates the linear
# and/or angular acceleration to be applied to its owning agent
# 
# The entry point for all behaviors is the `calculate_steering` function. Everything else is
# self-contained within the behavior.


# Whether this behavior is enabled. All disabled behaviors return zero amounts of acceleration.
# Defaults to true
var enabled := true
# The agent on which all steering calculations are to be made.
var agent: GSTSteeringAgent


# Initializes the behavior
func _init(agent: GSTSteeringAgent) -> void:
	self.agent = agent


# Returns the `acceleration` parameter modified with the behavior's desired amount of acceleration
func calculate_steering(acceleration: GSTTargetAcceleration) -> GSTTargetAcceleration:
	if enabled:
		return _calculate_steering(acceleration)
	else:
		acceleration.set_zero()
		return acceleration


func _calculate_steering(acceleration: GSTTargetAcceleration) -> GSTTargetAcceleration:
	acceleration.set_zero()
	return acceleration
