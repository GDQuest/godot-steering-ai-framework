extends GSTSteeringBehavior
class_name GSTCohesion
# Group behavior that produces linear acceleration that attempts to move the agent towards the
# center of mass of the agents in the area defined by the defined Proximity.


var center_of_mass: Vector3
var proximity: GSTProximity


func _init(agent: GSTSteeringAgent, proximity: GSTProximity).(agent) -> void:
	self.proximity = proximity


func _calculate_steering(acceleration: GSTTargetAcceleration) -> GSTTargetAcceleration:
	acceleration.set_zero()
	center_of_mass = Vector3.ZERO
	var neighbor_count = proximity.find_neighbors(funcref(self, "_report_neighbor"))
	if neighbor_count > 0:
		center_of_mass *= 1.0 / neighbor_count
		acceleration.linear = (center_of_mass - agent.position).normalized() * agent.max_linear_acceleration
	return acceleration


func _report_neighbor(neighbor: GSTSteeringAgent) -> bool:
	center_of_mass += neighbor.position
	return true
