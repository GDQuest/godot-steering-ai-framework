# Steers the agent to avoid obstacles in its path. Approximates obstacles as
# spheres.
# category: Group behaviors
class_name GSAIAvoidCollisions
extends GSAIGroupBehavior

var _first_neighbor: GSAISteeringAgent
var _shortest_time: float
var _first_minimum_separation: float
var _first_distance: float
var _first_relative_position: Vector3
var _first_relative_velocity: Vector3


func _init(agent: GSAISteeringAgent, proximity: GSAIProximity).(agent, proximity) -> void:
	pass


func _calculate_steering(acceleration: GSAITargetAcceleration) -> void:
	_shortest_time = INF
	_first_neighbor = null
	_first_minimum_separation = 0
	_first_distance = 0

	var neighbor_count := proximity._find_neighbors(_callback)

	if neighbor_count == 0 or not _first_neighbor:
		acceleration.set_zero()
	else:
		if (
			_first_minimum_separation <= 0
			or _first_distance < agent.bounding_radius + _first_neighbor.bounding_radius
		):
			acceleration.linear = _first_neighbor.position - agent.position
		else:
			acceleration.linear = (
				_first_relative_position
				+ (_first_relative_velocity * _shortest_time)
			)

	acceleration.linear = (acceleration.linear.normalized() * -agent.linear_acceleration_max)
	acceleration.angular = 0


# Callback for the proximity to call when finding neighbors. Keeps track of every `neighbor`
# that was found but only keeps the one the owning agent will most likely collide with.
# tags: virtual
func _report_neighbor(neighbor: GSAISteeringAgent) -> bool:
	var relative_position := neighbor.position - agent.position
	var relative_velocity := neighbor.linear_velocity - agent.linear_velocity
	var relative_speed_squared := relative_velocity.length_squared()

	if relative_speed_squared == 0:
		return false
	else:
		var time_to_collision = -relative_position.dot(relative_velocity) / relative_speed_squared

		if time_to_collision <= 0 or time_to_collision >= _shortest_time:
			return false
		else:
			var distance = relative_position.length()
			var minimum_separation: float = (
				distance
				- sqrt(relative_speed_squared) * time_to_collision
			)
			if minimum_separation > agent.bounding_radius + neighbor.bounding_radius:
				return false
			else:
				_shortest_time = time_to_collision
				_first_neighbor = neighbor
				_first_minimum_separation = minimum_separation
				_first_distance = distance
				_first_relative_position = relative_position
				_first_relative_velocity = relative_velocity
				return true
