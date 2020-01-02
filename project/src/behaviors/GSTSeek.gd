extends GSTSteeringBehavior
class_name GSTSeek
# Calculates acceleration to take an agent to a target agent's position as directly as possible


var target: GSTAgentLocation


func _init(agent: GSTSteeringAgent, target: GSTAgentLocation).(agent) -> void:
	self.target = target


func _calculate_steering(acceleration: GSTTargetAcceleration) -> GSTTargetAcceleration:
	acceleration.linear = (
			(target.position - agent.position).normalized() * agent.max_linear_acceleration)
	acceleration.angular = 0
	
	return acceleration
