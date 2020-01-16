extends GSTMatchOrientation
class_name GSTLookWhereYouGo
# Calculates an angular acceleration to match an agent's orientation to its direction of travel.


func _init(agent: GSTSteeringAgent).(agent, null) -> void:
	pass


func _calculate_steering(accel: GSTTargetAcceleration) -> GSTTargetAcceleration:
	if agent.linear_velocity.length_squared() < agent.zero_linear_speed_threshold:
		accel.set_zero()
		return accel
	else:
		var orientation := atan2(agent.linear_velocity.x, -agent.linear_velocity.y)
		return _match_orientation(accel, orientation)
