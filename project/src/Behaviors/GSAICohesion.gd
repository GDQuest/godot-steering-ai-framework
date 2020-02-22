# Calculates an acceleration that attempts to move the agent towards the center
# of mass of the agents in the area defined by the `GSAIProximity`.
# category: Group behaviors
class_name GSAICohesion
extends GSAIGroupBehavior

var _center_of_mass: Vector3


func _init(agent: GSAISteeringAgent, proximity: GSAIProximity).(agent, proximity) -> void:
	pass


func _calculate_steering(acceleration: GSAITargetAcceleration) -> void:
	acceleration.set_zero()
	_center_of_mass = Vector3.ZERO
	var neighbor_count = proximity._find_neighbors(_callback)
	if neighbor_count > 0:
		_center_of_mass *= 1.0 / neighbor_count
		acceleration.linear = (
			(_center_of_mass - agent.position).normalized()
			* agent.linear_acceleration_max
		)


# Callback for the proximity to call when finding neighbors. Adds `neighbor`'s position
# to the center of mass of the group.
# tags: virtual
func _report_neighbor(neighbor: GSAISteeringAgent) -> bool:
	_center_of_mass += neighbor.position
	return true
