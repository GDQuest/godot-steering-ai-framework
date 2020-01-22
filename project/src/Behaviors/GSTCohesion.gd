class_name GSTCohesion
extends GSTGroupBehavior
# Group behavior that produces linear acceleration that attempts to move the agent towards the
# center of mass of the agents in the area defined by the defined Proximity.


var center_of_mass: Vector3


func _init(agent: GSTSteeringAgent, proximity: GSTProximity).(agent, proximity) -> void:
	pass


func _calculate_steering(acceleration: GSTTargetAcceleration) -> GSTTargetAcceleration:
	acceleration.set_zero()
	center_of_mass = Vector3.ZERO
	var neighbor_count = proximity.find_neighbors(_callback)
	if neighbor_count > 0:
		center_of_mass *= 1.0 / neighbor_count
		acceleration.linear = (center_of_mass - agent.position).normalized() * agent.linear_acceleration_max
	return acceleration


func report_neighbor(neighbor: GSTSteeringAgent) -> bool:
	center_of_mass += neighbor.position
	return true
