extends MatchOrientation
class_name Face


func _init(agent: SteeringAgent, target: AgentLocation).(agent, target) -> void:
	pass


func _face(acceleration: TargetAcceleration, target_position: Vector3) -> TargetAcceleration:
	var to_target: = target_position - agent.position
	
	var distance_squared: = to_target.length_squared()
	if distance_squared < agent.zero_linear_speed_threshold:
		return acceleration.set_zero()
	
	var orientation = Vector3.UP.angle_to(to_target)
	
	return _match_orientation(acceleration, orientation)


func _calculate_internal_steering(acceleration: TargetAcceleration) -> TargetAcceleration:
	return _face(acceleration, target.position)
