extends Node2D


onready var player := $Player
onready var gui := $GUI
onready var turret := $Turret

export(int, 0, 359) var max_angular_speed := 90 setget set_max_angular_speed
export(int, 0, 359) var max_angular_accel := 5 setget set_max_angular_accel
export(int, 0, 180) var align_tolerance := 5 setget set_align_tolerance
export(int, 0, 359) var deceleration_radius := 45 setget set_deceleration_radius
export(float, 0, 1000) var player_speed := 600.0 setget set_player_speed


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
	if not is_inside_tree():
		return
	
	align_tolerance = value
	turret.face.alignment_tolerance = deg2rad(value)


func set_deceleration_radius(value: int) -> void:
	if not is_inside_tree():
		return
	
	deceleration_radius = value
	turret.face.deceleration_radius = deg2rad(value)


func set_max_angular_accel(value: int) -> void:
	if not is_inside_tree():
		return
	
	max_angular_accel = value
	turret.agent.max_angular_acceleration = deg2rad(value)


func set_max_angular_speed(value: int) -> void:
	if not is_inside_tree():
		return
	
	max_angular_speed = value
	turret.agent.max_angular_speed = deg2rad(value)


func set_player_speed(value: float) -> void:
	if not is_inside_tree():
		return
	
	player_speed = value
	player.speed = player_speed
