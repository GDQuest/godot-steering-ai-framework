extends SteeringBehavior
class_name Arrive
"""
Calculates acceleration to take an agent to its target's location.
The calculation will attempt to arrive with zero remaining velocity.
"""


var target: AgentLocation
var arrival_tolerance: float
var deceleration_radius: float
var time_to_target: = 0.1


func _init(agent: SteeringAgent, target: AgentLocation).(agent) -> void:
	self.target = target


func _arrive(acceleration: TargetAcceleration, target_position: Vector3) -> TargetAcceleration:
	var to_target: = target_position - agent.position
	var distance: = to_target.length()
	
	if distance <= arrival_tolerance:
		return acceleration.set_zero()
	
	var target_speed: = agent.max_linear_speed
	
	if distance <= deceleration_radius:
		target_speed *= distance / deceleration_radius
	
	var target_velocity: = to_target * target_speed/distance
	
	target_velocity = (target_velocity - agent.linear_velocity) * 1.0 / time_to_target
	
	acceleration.linear = limit_length(target_velocity, agent.max_linear_acceleration)
	acceleration.angular = 0
	
	return acceleration


func _calculate_internal_steering(acceleration: TargetAcceleration) -> TargetAcceleration:
	return _arrive(acceleration, target.position)


static func limit_length(vector: Vector3, limit: float) -> Vector3:
	var len2: = vector.length_squared()
	var limit2: = limit * limit
	if len2 > limit2:
		vector *= sqrt(limit2 / len2)
	return vector
