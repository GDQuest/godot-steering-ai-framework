extends Pursue
class_name Evade


func _init(agent: SteeringAgent, target: SteeringAgent, max_predict_time: = 1.0).(agent, target, max_predict_time):
	pass


func get_max_linear_acceleration() -> float:
	return -agent.max_linear_acceleration
