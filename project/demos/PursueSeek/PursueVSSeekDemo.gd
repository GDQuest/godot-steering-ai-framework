extends Node2D


onready var pursuer := $BoundaryManager/Pursuer
onready var seeker := $BoundaryManager/Seeker

export(float, 0, 2000, 40) var max_linear_speed := 200.0 setget set_max_linear_speed
export(float, 0, 200, 1) var max_linear_accel := 10.0 setget set_max_linear_accel
export(float, 0, 5, 0.1) var predict_time := 2.0 setget set_predict_time


func set_max_linear_speed(value: float) -> void:
	if not is_inside_tree():
		return
	
	max_linear_speed = value
	pursuer.agent.max_linear_speed = value
	seeker.agent.max_linear_speed = value


func set_max_linear_accel(value: float) -> void:
	if not is_inside_tree():
		return
	
	max_linear_accel = value
	pursuer.agent.max_linear_acceleration = value
	seeker.agent.max_linear_acceleration = value


func set_predict_time(value: float) -> void:
	if not is_inside_tree():
		return
	
	predict_time = value
	pursuer._behavior.max_predict_time = value
