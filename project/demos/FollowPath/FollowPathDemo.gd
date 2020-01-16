extends Node2D


export(float, 0, 2000, 40) var max_linear_speed := 600.0 setget set_max_linear_speed
export(float, 0, 200, 10.0) var max_linear_acceleration := 40.0 setget set_max_linear_acceleration
export(float, 0, 100, 0.1) var arrival_tolerance := 10.0 setget set_arrival_tolerance
export(float, 0, 500, 10) var deceleration_radius := 100.0 setget set_deceleration_radius
export(float, 0, 5, 0.1) var predict_time := 0.3 setget set_predict_time
export(float, 0, 200, 10.0) var path_offset := 20.0 setget set_path_offset

onready var drawer := $Drawer
onready var follower := $PathFollower


func _ready() -> void:
	follower.setup(
			path_offset,
			predict_time,
			max_linear_acceleration,
			max_linear_speed,
			deceleration_radius,
			arrival_tolerance
	)


func set_max_linear_speed(value: float) -> void:
	max_linear_speed = value
	if not is_inside_tree():
		return
	
	follower.agent.max_linear_speed = value


func set_max_linear_acceleration(value: float) -> void:
	max_linear_acceleration = value
	if not is_inside_tree():
		return
	
	follower.agent.max_linear_acceleration = value


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
