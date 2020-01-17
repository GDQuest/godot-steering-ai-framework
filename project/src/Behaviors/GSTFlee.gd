class_name GSTFlee
extends GSTSeek
# Calculates acceleration to take an agent directly away from a target agent.


func _init(agent: GSTSteeringAgent, target: GSTAgentLocation).(agent, target) -> void:
	pass


func _calculate_steering(acceleration: GSTTargetAcceleration) -> GSTTargetAcceleration:
	acceleration.linear = (
			(agent.position - target.position).normalized() * agent.max_linear_acceleration)
	acceleration.angular = 0
	
	return acceleration
