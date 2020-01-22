class_name GSTEvade
extends GSTPursue
# Calculates acceleration to take an agent away from where a target agent will be.

# # The `predict_time_max` variable represents how far ahead to calculate the intersection point.


func _init(
		agent: GSTSteeringAgent,
		target: GSTSteeringAgent,
		predict_time_max := 1.0).(agent, target, predict_time_max):
	pass


func _get_modified_acceleration() -> float:
	return -agent.linear_acceleration_max
