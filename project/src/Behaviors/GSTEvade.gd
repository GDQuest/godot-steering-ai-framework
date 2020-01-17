class_name GSTEvade
extends GSTPursue
# Calculates acceleration to take an agent away from where a target agent will be.

# # The `max_predict_time` variable represents how far ahead to calculate the intersection point.


func _init(
		agent: GSTSteeringAgent,
		target: GSTSteeringAgent,
		max_predict_time := 1.0).(agent, target, max_predict_time):
	pass


func _get_modified_acceleration() -> float:
	return -agent.max_linear_acceleration
