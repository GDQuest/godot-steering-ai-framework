class_name GSTLookWhereYouGo
extends GSTMatchOrientation
# Calculates an angular acceleration to match an agent's orientation to its direction of travel.


# Initializes the behavior
func _init(agent: GSTSteeringAgent).(agent, null) -> void:
	pass


func _calculate_steering(accel: GSTTargetAcceleration) -> GSTTargetAcceleration:
	if agent.linear_velocity.length_squared() < agent.zero_linear_speed_threshold:
		accel.set_zero()
		return accel
	else:
		var orientation := GSTUtils.vector_to_angle(agent.linear_velocity)
		return _match_orientation(accel, orientation)
