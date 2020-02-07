# Calculates an angular acceleration to match an agent's orientation to its
# direction of travel.
class_name GSTLookWhereYouGo
extends GSTMatchOrientation


func _init(agent: GSTSteeringAgent).(agent, null) -> void:
	pass


func _calculate_steering(accel: GSTTargetAcceleration) -> void:
	if agent.linear_velocity.length_squared() < agent.zero_linear_speed_threshold:
		accel.set_zero()
	else:
		var orientation := GSTUtils.vector3_to_angle(agent.linear_velocity)
		_match_orientation(accel, orientation)
