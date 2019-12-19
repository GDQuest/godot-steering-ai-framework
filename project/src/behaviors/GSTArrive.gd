extends GSTSteeringBehavior
class_name GSTArrive
"""
Calculates acceleration to take an agent to its target's location.
The calculation will attempt to arrive with zero remaining velocity.
"""


var target: GSTAgentLocation
var arrival_tolerance: float
var deceleration_radius: float
var time_to_reach: = 0.1


func _init(agent: GSTSteeringAgent, target: GSTAgentLocation).(agent) -> void:
	self.target = target


func _arrive(acceleration: GSTTargetAcceleration, target_position: Vector3) -> GSTTargetAcceleration:
	var to_target: = target_position - agent.position
	var distance: = to_target.length()
	
	if distance <= arrival_tolerance:
		acceleration.set_zero()
	else:
		var desired_speed: = agent.max_linear_speed
		
		if distance <= deceleration_radius:
			desired_speed *= distance / deceleration_radius
		
		var desired_velocity: = to_target * desired_speed/distance
		
		desired_velocity = (desired_velocity - agent.linear_velocity) * 1.0 / time_to_reach
		
		acceleration.linear = Utils.clampedv3(desired_velocity, agent.max_linear_acceleration)
		acceleration.angular = 0
	
	return acceleration


func _calculate_steering(acceleration: GSTTargetAcceleration) -> GSTTargetAcceleration:
	return _arrive(acceleration, target.position)
