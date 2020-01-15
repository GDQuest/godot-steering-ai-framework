extends Node2D


onready var player: = $Player
onready var gui: = $GUI
onready var turret: = $Turret

export(int, 0, 359, 1) var max_angular_speed: = 90 setget set_max_angular_speed
export(int, 0, 359, 1) var max_angular_accel: = 5 setget set_max_angular_accel
export(int, 0, 180, 1) var align_tolerance: = 5 setget set_align_tolerance
export(int, 0, 359, 1) var deceleration_radius: = 45 setget set_deceleration_radius


func _ready() -> void:
	turret.setup(
			deg2rad(align_tolerance),
			deg2rad(deceleration_radius),
			deg2rad(max_angular_accel),
			deg2rad(max_angular_speed)
		)


func set_align_tolerance(value: int) -> void:
	align_tolerance = value
	if turret:
		turret._face.alignment_tolerance = deg2rad(value)


func set_deceleration_radius(value: int) -> void:
	deceleration_radius = value
	if turret:
		turret._face.deceleration_radius = deg2rad(value)


func set_max_angular_accel(value: int) -> void:
	max_angular_accel = value
	if turret:
		turret._agent.max_angular_acceleration = deg2rad(value)


func set_max_angular_speed(value: int) -> void:
	max_angular_speed = value
	if turret:
		turret._agent.max_angular_speed = deg2rad(value)
