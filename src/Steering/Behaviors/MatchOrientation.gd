extends SteeringBehavior
class_name MatchOrientation


var target: AgentLocation
var alignment_tolerance: float
var deceleration_radius: float
var time_to_target: float = 0.1


func _init(agent: SteeringAgent, target: AgentLocation).(agent) -> void:
	self.target = target


func _match_orientation(acceleration: TargetAcceleration, target_orientation: float) -> TargetAcceleration:
	var rotation: = wrapf(target_orientation - agent.orientation, -PI, PI)

	var rotation_size: = -rotation if rotation < 0 else rotation

	if rotation_size <= alignment_tolerance:
		return acceleration.set_zero()
	
	var target_rotation: = agent.max_angular_speed

	if rotation_size <= deceleration_radius:
		target_rotation *= rotation_size / deceleration_radius
	
	target_rotation *= rotation / rotation_size

	acceleration.angular = (target_rotation - agent.angular_velocity) / time_to_target

	var limited_acceleration: = -acceleration.angular if acceleration.angular < 0 else acceleration.angular
	if limited_acceleration > agent.max_angular_acceleration:
		acceleration.angular *= agent.max_angular_acceleration / limited_acceleration
	
	acceleration.linear = Vector3.ZERO

	return acceleration


func _calculate_internal_steering(acceleration: TargetAcceleration) -> TargetAcceleration:
	return _match_orientation(acceleration, target.orientation)
