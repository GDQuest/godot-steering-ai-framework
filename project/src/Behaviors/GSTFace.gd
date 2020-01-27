class_name GSTFace
extends GSTMatchOrientation
# Calculates angular acceleration to rotate a target to face its target's position.
# The acceleration will attempt to arrive with zero remaining angular velocity.


func _init(agent: GSTSteeringAgent, target: GSTAgentLocation).(agent, target) -> void:
	pass


func _face(acceleration: GSTTargetAcceleration, target_position: Vector3) -> GSTTargetAcceleration:
	var to_target := target_position - agent.position
	var distance_squared := to_target.length_squared()
	
	if distance_squared < agent.zero_linear_speed_threshold:
		acceleration.set_zero()
		return acceleration
	else:
		var orientation = GSTUtils.vector_to_angle(to_target)
		return _match_orientation(acceleration, orientation)


func _calculate_steering(acceleration: GSTTargetAcceleration) -> GSTTargetAcceleration:
	return _face(acceleration, target.position)
