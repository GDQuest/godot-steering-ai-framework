extends Node

export (float, 0, 2000, 40) var linear_speed_max := 600.0 setget set_linear_speed_max
export (float, 0, 9000, 10.0) var linear_acceleration_max := 40.0 setget set_linear_acceleration_max
export (float, 0, 100, 0.1) var arrival_tolerance := 10.0 setget set_arrival_tolerance
export (float, 0, 500, 10) var deceleration_radius := 100.0 setget set_deceleration_radius
export (float, 0, 5, 0.1) var predict_time := 0.3 setget set_predict_time
export (float, 0, 200, 10.0) var path_offset := 20.0 setget set_path_offset

onready var drawer := $Drawer
onready var follower := $PathFollower


func _ready() -> void:
	follower.setup(
		path_offset,
		predict_time,
		linear_acceleration_max,
		linear_speed_max,
		deceleration_radius,
		arrival_tolerance
	)


func set_linear_speed_max(value: float) -> void:
	linear_speed_max = value
	if not is_inside_tree():
		return

	follower.agent.linear_speed_max = value


func set_linear_acceleration_max(value: float) -> void:
	linear_acceleration_max = value
	if not is_inside_tree():
		return

	follower.agent.linear_acceleration_max = value


func set_arrival_tolerance(value: float) -> void:
	arrival_tolerance = value
	if not is_inside_tree():
		return

	follower.follow.arrival_tolerance = value


func set_deceleration_radius(value: float) -> void:
	deceleration_radius = value
	if not is_inside_tree():
		return

	follower.follow.deceleration_radius = value


func set_predict_time(value: float) -> void:
	predict_time = value
	if not is_inside_tree():
		return

	follower.follow.prediction_time = value


func set_path_offset(value: float) -> void:
	path_offset = value
	if not is_inside_tree():
		return

	follower.follow.path_offset = value
