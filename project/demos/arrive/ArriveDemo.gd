extends Node2D


onready var target: = $Target
onready var arriver: = $Arriver
onready var gui: = $GUI

export(float, 0, 2000, 40) var max_linear_speed: = 200.0 setget set_max_linear_speed
export(float, 0, 200, 1) var max_linear_accel: = 25.0 setget set_max_linear_accel
export(float, 0, 100, 0.1) var arrival_tolerance: = 20.0 setget set_arrival_tolerance
export(float, 0, 500, 10) var deceleration_radius: = 200.0 setget set_deceleration_radius


func _ready() -> void:
	target.position = arriver.global_position


func set_arrival_tolerance(value: float) -> void:
	arrival_tolerance = value
	if arriver:
		arriver.arrive.arrival_tolerance = value


func set_deceleration_radius(value: float) -> void:
	deceleration_radius = value
	if arriver:
		arriver.arrive.deceleration_radius = value


func set_max_linear_speed(value: float) -> void:
	max_linear_speed = value
	if arriver:
		arriver.agent.max_linear_speed = value


func set_max_linear_accel(value: float) -> void:
	max_linear_accel = value
	if arriver:
		arriver.agent.max_linear_acceleration = value
