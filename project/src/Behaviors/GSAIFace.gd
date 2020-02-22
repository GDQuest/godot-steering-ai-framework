# Calculates angular acceleration to rotate a target to face its target's
# position. The behavior attemps to arrive with zero remaining angular velocity.
# category: Individual behaviors
class_name GSAIFace
extends GSAIMatchOrientation


func _init(agent: GSAISteeringAgent, target: GSAIAgentLocation, use_z := false).(
	agent, target, use_z
) -> void:
	pass


func _face(acceleration: GSAITargetAcceleration, target_position: Vector3) -> void:
	var to_target := target_position - agent.position
	var distance_squared := to_target.length_squared()

	if distance_squared < agent.zero_linear_speed_threshold:
		acceleration.set_zero()
	else:
		var orientation = (
			GSAIUtils.vector3_to_angle(to_target)
			if use_z
			else GSAIUtils.vector2_to_angle(GSAIUtils.to_vector2(to_target))
		)
		_match_orientation(acceleration, orientation)


func _calculate_steering(acceleration: GSAITargetAcceleration) -> void:
	_face(acceleration, target.position)
