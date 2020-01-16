extends Node2D


onready var player := $Player
onready var gui := $GUI
onready var turret := $Turret

export(int, 0, 359, 2) var max_angular_speed := 120 setget set_max_angular_speed
export(int, 0, 359, 2) var max_angular_accel := 10 setget set_max_angular_accel
export(int, 0, 180, 2) var align_tolerance := 5 setget set_align_tolerance
export(int, 0, 359, 2) var deceleration_radius := 45 setget set_deceleration_radius
export(float, 0, 1000, 40) var player_speed := 600.0 setget set_player_speed


func _ready() -> void:
	player.speed = player_speed
	turret.setup(
		player.agent,
		deg2rad(align_tolerance),
		deg2rad(deceleration_radius),
		deg2rad(max_angular_accel),
		deg2rad(max_angular_speed)
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


func set_max_angular_accel(value: int) -> void:
	max_angular_accel = value
	if not is_inside_tree():
		return
	
	turret.agent.max_angular_acceleration = deg2rad(value)


func set_max_angular_speed(value: int) -> void:
	max_angular_speed = value
	if not is_inside_tree():
		return
	
	turret.agent.max_angular_speed = deg2rad(value)


func set_player_speed(value: float) -> void:
	player_speed = value
	if not is_inside_tree():
		return
	
	player.speed = player_speed
