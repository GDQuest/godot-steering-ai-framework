extends Node

export (float, 0, 100, 5) var linear_speed_max := 10.0 setget set_linear_speed_max
export (float, 0, 100, 0.1) var linear_acceleration_max := 1.0 setget set_linear_acceleration_max
export (float, 0, 50, 0.1) var arrival_tolerance := 0.5 setget set_arrival_tolerance
export (float, 0, 50, 0.1) var deceleration_radius := 5.0 setget set_deceleration_radius
export (int, 0, 1080, 10) var angular_speed_max := 270 setget set_angular_speed_max
export (int, 0, 2048, 10) var angular_accel_max := 45 setget set_angular_accel_max
export (int, 0, 178, 2) var align_tolerance := 5 setget set_align_tolerance
export (int, 0, 180, 2) var angular_deceleration_radius := 45 setget set_angular_deceleration_radius

onready var target := $MouseTarget
onready var arriver := $Arriver


func _ready() -> void:
	arriver.setup(
		deg2rad(align_tolerance),
		deg2rad(angular_deceleration_radius),
		deg2rad(angular_accel_max),
		deg2rad(angular_speed_max),
		deceleration_radius,
		arrival_tolerance,
		linear_acceleration_max,
		linear_speed_max,
		target
	)
	$Camera.setup(target)


func set_align_tolerance(value: int) -> void:
	align_tolerance = value
	if not is_inside_tree():
		return

	arriver.face.alignment_tolerance = deg2rad(value)


func set_angular_deceleration_radius(value: int) -> void:
	deceleration_radius = value
	if not is_inside_tree():
		return

	arriver.face.deceleration_radius = deg2rad(value)


func set_angular_accel_max(value: int) -> void:
	angular_accel_max = value
	if not is_inside_tree():
		return

	arriver.agent.angular_acceleration_max = deg2rad(value)


func set_angular_speed_max(value: int) -> void:
	angular_speed_max = value
	if not is_inside_tree():
		return

	arriver.agent.angular_speed_max = deg2rad(value)


func set_arrival_tolerance(value: float) -> void:
	arrival_tolerance = value
	if not is_inside_tree():
		return

	arriver.arrive.arrival_tolerance = value


func set_deceleration_radius(value: float) -> void:
	deceleration_radius = value
	if not is_inside_tree():
		return

	arriver.arrive.deceleration_radius = value


func set_linear_speed_max(value: float) -> void:
	linear_speed_max = value
	if not is_inside_tree():
		return

	arriver.agent.linear_speed_max = value


func set_linear_acceleration_max(value: float) -> void:
	linear_acceleration_max = value
	if not is_inside_tree():
		return

	arriver.agent.linear_acceleration_max = value
