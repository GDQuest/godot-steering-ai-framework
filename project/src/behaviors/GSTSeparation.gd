extends GSTSteeringBehavior
class_name GSTSeparation
# Group behavior that produces acceleration repelling from the other neighbors that are in the
# immediate area defined by the given `GSTProximity`.

# # The produced acceleration is an average of all agents under consideration, multiplied by a
# # strength decreasing by the inverse square law in relation to distance, and accumulated.
# # In effect, all neighbors produce a single repelling force.


var decay_coefficient: = 1.0

var acceleration: GSTTargetAcceleration
var proximity: GSTProximity


func _init(agent: GSTSteeringAgent, proximity: GSTProximity).(agent) -> void:
	self.proximity = proximity


func _calculate_steering(acceleration: GSTTargetAcceleration) -> GSTTargetAcceleration:
	acceleration.set_zero()
	self.acceleration = acceleration
	proximity.find_neighbors(funcref(self, "_report_neighbor"))
	return acceleration


func _report_neighbor(neighbor: GSTSteeringAgent) -> bool:
	var to_agent: = agent.position - neighbor.position

	var distance_squared: = to_agent.length_squared()
	var max_acceleration: = agent.max_linear_acceleration

	var strength: = decay_coefficient / distance_squared
	if strength > max_acceleration:
		strength = max_acceleration
	
	acceleration.linear += to_agent * (strength / sqrt(distance_squared))

	return true
