extends Node2D


onready var pursuer: = $BoundaryManager/Pursuer
onready var seeker: = $BoundaryManager/Seeker

export(float, 0, 2000, 40) var max_linear_speed: = 200.0 setget set_max_linear_speed
export(float, 0, 200, 1) var max_linear_accel: = 10.0 setget set_max_linear_accel
export(float, 0, 5, 0.1) var predict_time: = 2.0 setget set_predict_time


func set_max_linear_speed(value: float) -> void:
	max_linear_speed = value
	if pursuer:
		pursuer.agent.max_linear_speed = value
	if seeker:
		seeker.agent.max_linear_speed = value


func set_max_linear_accel(value: float) -> void:
	max_linear_accel = value
	if pursuer:
		pursuer.agent.max_linear_acceleration = value
	if seeker:
		seeker.agent.max_linear_acceleration = value


func set_predict_time(value: float) -> void:
	predict_time = value
	if pursuer:
		pursuer._behavior.max_predict_time = value
