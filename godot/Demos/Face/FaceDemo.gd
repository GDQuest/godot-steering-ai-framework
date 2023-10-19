extends Node

@export_range(0, 1080, 2) var angular_speed_max := 120: set = set_angular_speed_max
@export_range(0, 2048, 2) var angular_accel_max := 10: set = set_angular_accel_max
@export_range(0, 180, 2) var align_tolerance := 5: set = set_align_tolerance
@export_range(0, 359, 2) var deceleration_radius := 45: set = set_deceleration_radius
@export_range(0, 1000, 40) var player_speed := 600.0: set = set_player_speed

@onready var player := $Player
@onready var turret := $Turret


func _ready() -> void:
	get_tree().root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	get_tree().root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_EXPAND
	
	player.speed = player_speed
	turret.setup(
		player.agent,
		deg_to_rad(align_tolerance),
		deg_to_rad(deceleration_radius),
		deg_to_rad(angular_accel_max),
		deg_to_rad(angular_speed_max)
	)


func set_align_tolerance(value: int) -> void:
	align_tolerance = value
	if not is_inside_tree():
		return

	turret.face.alignment_tolerance = deg_to_rad(value)


func set_deceleration_radius(value: int) -> void:
	deceleration_radius = value
	if not is_inside_tree():
		return

	turret.face.deceleration_radius = deg_to_rad(value)


func set_angular_accel_max(value: int) -> void:
	angular_accel_max = value
	if not is_inside_tree():
		return

	turret.agent.angular_acceleration_max = deg_to_rad(value)


func set_angular_speed_max(value: int) -> void:
	angular_speed_max = value
	if not is_inside_tree():
		return

	turret.agent.angular_speed_max = deg_to_rad(value)


func set_player_speed(value: float) -> void:
	player_speed = value
	if not is_inside_tree():
		return

	player.speed = player_speed
