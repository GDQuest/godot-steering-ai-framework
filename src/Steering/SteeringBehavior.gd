extends Reference
class_name SteeringBehavior
"""
Base class to calculate how an AI agent steers itself.
"""


var enabled: = true
var agent: SteeringAgent


func _init(agent: SteeringAgent) -> void:
	self.agent = agent


func calculate_steering(acceleration: TargetAcceleration) -> TargetAcceleration:
	return _calculate_internal_steering(acceleration) if enabled else acceleration.zero()


func _calculate_internal_steering(acceleration: TargetAcceleration) -> TargetAcceleration:
	return acceleration.set_zero()
