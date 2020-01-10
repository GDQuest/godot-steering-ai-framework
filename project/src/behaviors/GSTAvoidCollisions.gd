extends GSTGroupBehavior
class_name GSTAvoidCollisions
# Behavior that steers the agent to avoid obstacles lying in its path, approximated by a sphere.


var first_neighbor: GSTSteeringAgent
var shortest_time: float
var first_minimum_separation: float
var first_distance: float
var first_relative_position: Vector3
var first_relative_velocity: Vector3


func _init(agent: GSTSteeringAgent, proximity: GSTProximity).(agent, proximity) -> void:
	pass


func _calculate_steering(acceleration: GSTTargetAcceleration) -> GSTTargetAcceleration:
	shortest_time = INF
	first_neighbor = null
	first_minimum_separation = 0
	first_distance = 0
	
	var neighbor_count: = proximity.find_neighbors(_callback)
	
	if neighbor_count == 0 or not first_neighbor:
		acceleration.set_zero()
	else:
		if(
				first_minimum_separation <= 0 or 
				first_distance < agent.bounding_radius + first_neighbor.bounding_radius):
			acceleration.linear = first_neighbor.position - agent.position
		else:
			acceleration.linear = first_relative_position + (first_relative_velocity * shortest_time)
			acceleration.linear = acceleration.linear.normalized() * -agent.max_linear_acceleration
			acceleration.angular = 0
	
	return acceleration


func report_neighbor(neighbor: GSTSteeringAgent) -> bool:
	var relative_position: = neighbor.position - agent.position
	var relative_velocity: = neighbor.linear_velocity - agent.linear_velocity
	var relative_speed_squared: = relative_velocity.length_squared()
	
	if relative_speed_squared == 0:
		return false
	else:
		var time_to_collision = -relative_position.dot(relative_velocity) / relative_speed_squared
		
		if time_to_collision <= 0 or time_to_collision >= shortest_time:
			return false
		else:
			var distance = relative_position.length()
			var minimum_separation: float = distance - sqrt(relative_speed_squared) * time_to_collision
			if minimum_separation > agent.bounding_radius + neighbor.bounding_radius:
				return false
			else:
				shortest_time = time_to_collision
				first_neighbor = neighbor
				first_minimum_separation = minimum_separation
				first_distance = distance
				first_relative_position = relative_position
				first_relative_velocity = relative_velocity
				return true
