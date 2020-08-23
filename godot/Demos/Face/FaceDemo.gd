extends Node

export (int, 0, 1080, 2) var angular_speed_max := 120 setget set_angular_speed_max
export (int, 0, 2048, 2) var angular_accel_max := 10 setget set_angular_accel_max
export (int, 0, 180, 2) var align_tolerance := 5 setget set_align_tolerance
export (int, 0, 359, 2) var deceleration_radius := 45 setget set_deceleration_radius
export (float, 0, 1000, 40) var player_speed := 600.0 setget set_player_speed

onready var player := $Player
onready var turret := $Turret


func _ready() -> void:
	player.speed = player_speed
	turret.setup(
		player.agent,
		deg2rad(align_tolerance),
		deg2rad(deceleration_radius),
		deg2rad(angular_accel_max),
		deg2rad(angular_speed_max)
	)


func set_align_tolerance(value: int) -> void:
	align_tolerance = value
	if not is_inside_tree():
		return

	turret.face.alignment_tolerance = deg2rad(value)


func set_deceleration_radius(value: int) -> void:
	deceleration_radius = value
	if not is_inside_tree():
		return

	turret.face.deceleration_radius = deg2rad(value)


func set_angular_accel_max(value: int) -> void:
	angular_accel_max = value
	if not is_inside_tree():
		return

	turret.agent.angular_acceleration_max = deg2rad(value)


func set_angular_speed_max(value: int) -> void:
	angular_speed_max = value
	if not is_inside_tree():
		return

	turret.agent.angular_speed_max = deg2rad(value)


func set_player_speed(value: float) -> void:
	player_speed = value
	if not is_inside_tree():
		return

	player.speed = player_speed
