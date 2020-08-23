extends Node

export (float, 0, 2000, 40) var linear_speed_max := 120.0 setget set_linear_speed_max
export (float, 0, 2000, 20) var linear_accel_max := 10.0 setget set_linear_accel_max
export (float, 0, 5, 0.1) var predict_time := 1.0 setget set_predict_time

onready var pursuer := $BoundaryManager/Pursuer
onready var seeker := $BoundaryManager/Seeker


func _ready() -> void:
	pursuer.setup(predict_time, linear_speed_max, linear_accel_max)
	seeker.setup(predict_time, linear_speed_max, linear_accel_max)


func set_linear_speed_max(value: float) -> void:
	linear_speed_max = value
	if not is_inside_tree():
		return

	pursuer.agent.linear_speed_max = value
	seeker.agent.linear_speed_max = value


func set_linear_accel_max(value: float) -> void:
	linear_accel_max = value
	if not is_inside_tree():
		return

	pursuer.agent.linear_acceleration_max = value
	seeker.agent.linear_acceleration_max = value


func set_predict_time(value: float) -> void:
	predict_time = value
	if not is_inside_tree():
		return

	pursuer._behavior.predict_time_max = value
