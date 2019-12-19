extends Reference
class_name GSTSteeringBehavior
"""
Base class to calculate how an AI agent steers itself.
"""


var enabled: = true
var agent: GSTSteeringAgent


func _init(agent: GSTSteeringAgent) -> void:
	self.agent = agent


func calculate_steering(acceleration: GSTTargetAcceleration) -> GSTTargetAcceleration:
	if enabled:
		return _calculate_steering(acceleration)
	else:
		acceleration.set_zero()
		return acceleration


func _calculate_steering(acceleration: GSTTargetAcceleration) -> GSTTargetAcceleration:
	acceleration.set_zero()
	return acceleration
