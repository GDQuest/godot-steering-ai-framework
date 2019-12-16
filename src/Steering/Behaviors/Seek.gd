extends SteeringBehavior
class_name Seek


var target: AgentLocation


func _init(agent: SteeringAgent, target: AgentLocation).(agent) -> void:
	self.target = target


func _calculate_internal_steering(acceleration: TargetAcceleration) -> TargetAcceleration:
	acceleration.linear = (target.position - agent.position).normalized() * agent.max_linear_acceleration
	acceleration.angular = 0
	
	return acceleration
