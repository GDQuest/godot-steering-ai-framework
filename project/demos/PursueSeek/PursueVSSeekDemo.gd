extends Node2D


export(float, 0, 2000, 40) var max_linear_speed := 120.0 setget set_max_linear_speed
export(float, 0, 200, 2) var max_linear_accel := 10.0 setget set_max_linear_accel
export(float, 0, 5, 0.1) var predict_time := 1.0 setget set_predict_time

onready var pursuer := $BoundaryManager/Pursuer
onready var seeker := $BoundaryManager/Seeker


func _ready() -> void:
	pursuer.setup(predict_time, max_linear_speed, max_linear_accel)
	seeker.setup(predict_time, max_linear_speed, max_linear_accel)


func set_max_linear_speed(value: float) -> void:
	max_linear_speed = value
	if not is_inside_tree():
		return
	
	pursuer.agent.max_linear_speed = value
	seeker.agent.max_linear_speed = value


func set_max_linear_accel(value: float) -> void:
	max_linear_accel = value
	if not is_inside_tree():
		return
	
	pursuer.agent.max_linear_acceleration = value
	seeker.agent.max_linear_acceleration = value


func set_predict_time(value: float) -> void:
	predict_time = value
	if not is_inside_tree():
		return
	
	pursuer._behavior.max_predict_time = value
