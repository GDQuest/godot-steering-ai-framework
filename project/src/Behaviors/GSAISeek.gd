# Calculates an acceleration to take an agent to a target agent's position
# directly.
# category: Individual behaviors
class_name GSAISeek
extends GSAISteeringBehavior

# The target that the behavior aims to move the agent to.
var target: GSAIAgentLocation


func _init(agent: GSAISteeringAgent, _target: GSAIAgentLocation).(agent) -> void:
	self.target = _target


func _calculate_steering(acceleration: GSAITargetAcceleration) -> void:
	acceleration.linear = (
		(target.position - agent.position).normalized()
		* agent.linear_acceleration_max
	)
	acceleration.angular = 0
