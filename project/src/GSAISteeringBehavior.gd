# Base class for all steering behaviors.
#
# Steering behaviors calculate the linear and the angular acceleration to be
# to the agent that owns them.
#
# The `calculate_steering` function is the entry point for all behaviors.
# Individual steering behaviors encapsulate the steering logic.
# category: Base types
class_name GSAISteeringBehavior

# If `false`, all calculations return zero amounts of acceleration.
var is_enabled := true
# The AI agent on which the steering behavior bases its calculations.
var agent: GSAISteeringAgent


func _init(_agent: GSAISteeringAgent) -> void:
	self.agent = _agent


# Sets the `acceleration` with the behavior's desired amount of acceleration.
func calculate_steering(acceleration: GSAITargetAcceleration) -> void:
	if is_enabled:
		_calculate_steering(acceleration)
	else:
		acceleration.set_zero()


func _calculate_steering(acceleration: GSAITargetAcceleration) -> void:
	acceleration.set_zero()
