extends Seek
class_name Flee
"""
Calculates acceleration to take an agent directly away from a target agent.
"""


func _init(agent: SteeringAgent, target: AgentLocation).(agent, target) -> void:
	pass


func _calculate_internal_steering(acceleration: TargetAcceleration) -> TargetAcceleration:
	acceleration.linear = (agent.position - target.position).normalized() * agent.max_linear_acceleration
	acceleration.angular = 0
	
	return acceleration
