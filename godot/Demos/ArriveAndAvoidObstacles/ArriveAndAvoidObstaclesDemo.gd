extends Node

signal path_established(points)

export (float, 0, 3200, 100) var linear_speed_max := 80000.0 setget set_linear_speed_max
export (float, 0, 10000, 100) var linear_acceleration_max := 8000.0 setget set_linear_acceleration_max
export (float, 0, 100, 0.1) var arrival_tolerance := 25.0 setget set_arrival_tolerance
export (float, 0, 500, 10) var deceleration_radius := 125.0 setget set_deceleration_radius
export (float, 0, 5, 0.1) var predict_time := 0.3 setget set_predict_time
export (float, 0, 200, 10.0) var path_offset := 20.0 setget set_path_offset



onready var target_drawer := $TargetDrawer
onready var path_drawer := $PathDrawer
onready var follower := $Arriver
onready var NavigationEngine := $Navigation2D

func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		
		target_drawer.target_position = Vector2(event.position.x, event.position.y)
		target_drawer.update()
		var path = NavigationEngine.get_simple_path(follower.global_position, target_drawer.target_position)
		emit_signal("path_established", path)
		path_drawer.active_points = path
		path_drawer.update()
		# TODO: update the path endpoint here


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
