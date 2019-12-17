extends SteeringBehavior
class_name Pursue
"""
Calculates acceleration to take an agent to intersect with where a target agent will be.

The `max_predict_time` variable represents how far ahead to calculate the intersection point.
"""


var target: SteeringAgent
var max_predict_time: float


func _init(agent: SteeringAgent, target: SteeringAgent, max_predict_time: = 1.0).(agent) -> void:
	self.target = target
	self.max_predict_time = max_predict_time


func get_max_linear_acceleration() -> float:
	return agent.max_linear_acceleration


func _calculate_internal_steering(acceleration: TargetAcceleration) -> TargetAcceleration:
	var target_position: = target.position
	var distance_squared: = (target_position - agent.position).length_squared()
	
	var speed_squared: = agent.linear_velocity.length_squared()
	var predict_time: = max_predict_time
	
	if speed_squared > 0:
		var predict_time_squared: = distance_squared / speed_squared
		if predict_time_squared < max_predict_time * max_predict_time:
			predict_time = sqrt(predict_time_squared)
	
	acceleration.linear = ((target_position + (target.linear_velocity * predict_time))-agent.position).normalized()
	acceleration.linear *= agent.max_linear_acceleration
	
	acceleration.angular = 0
	
	return acceleration
