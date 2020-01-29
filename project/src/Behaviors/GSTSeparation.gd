# Group behavior that produces acceleration that repels the agent from the other neighbors that
# are in the area defined by the given `GSTProximity`.
# 
# The produced acceleration is an average of all agents under consideration, multiplied by a
# strength decreasing by the inverse square law in relation to distance, and accumulated.
class_name GSTSeparation
extends GSTGroupBehavior


# The coefficient to calculate how fast the separation strength decays with distance.
var decay_coefficient := 1.0

var acceleration: GSTTargetAcceleration


func _init(agent: GSTSteeringAgent, proximity: GSTProximity).(agent, proximity) -> void:
	pass


func _calculate_steering(acceleration: GSTTargetAcceleration) -> GSTTargetAcceleration:
	acceleration.set_zero()
	self.acceleration = acceleration
	proximity.find_neighbors(_callback)
	return acceleration


# Callback for the proximity to call when finding neighbors. Determines the amount of
# acceleration that `neighbor` imposes based on its distance from the owner agent.
func report_neighbor(neighbor: GSTSteeringAgent) -> bool:
	var to_agent := agent.position - neighbor.position

	var distance_squared := to_agent.length_squared()
	var acceleration_max := agent.linear_acceleration_max

	var strength := decay_coefficient / distance_squared
	if strength > acceleration_max:
		strength = acceleration_max
	
	acceleration.linear += to_agent * (strength / sqrt(distance_squared))

	return true
