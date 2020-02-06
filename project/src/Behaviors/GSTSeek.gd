# Calculates an acceleration to take an agent to a target agent's position
# directly.
class_name GSTSeek
extends GSTSteeringBehavior


# The target that the behavior aims to move the agent to.
var target: GSTAgentLocation


func _init(agent: GSTSteeringAgent, target: GSTAgentLocation).(agent) -> void:
	self.target = target


func _calculate_steering(acceleration: GSTTargetAcceleration) -> void:
	acceleration.linear = (
			(target.position - agent.position).normalized() * agent.linear_acceleration_max)
	acceleration.angular = 0
