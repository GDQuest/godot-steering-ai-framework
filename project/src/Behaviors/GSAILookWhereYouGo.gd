# Calculates an angular acceleration to match an agent's orientation to its
# direction of travel.
class_name GSAILookWhereYouGo
extends GSAIMatchOrientation


func _init(agent: GSAISteeringAgent).(agent, null) -> void:
	pass


func _calculate_steering(accel: GSAITargetAcceleration) -> void:
	if agent.linear_velocity.length_squared() < agent.zero_linear_speed_threshold:
		accel.set_zero()
	else:
		var orientation := GSAIUtils.vector3_to_angle(agent.linear_velocity)
		_match_orientation(accel, orientation)
