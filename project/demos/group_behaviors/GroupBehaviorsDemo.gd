extends Node2D


onready var spawner: = $Spawner

export var max_linear_speed: = 100.0 setget set_max_linear_speed
export var max_linear_accel: = 25.0 setget set_max_linear_accel
export var proximity_radius: = 140.0 setget set_proximity_radius
export var show_proximity_radius: = true setget set_show_proximity_radius
export var separation_decay_coefficient: = 2000.0 setget set_separation_decay_coef
export var cohesion_strength: = 0.3 setget set_cohesion_strength
export var separation_strength: = 1.5 setget set_separation_strength


func _ready() -> void:
	pass


func set_max_linear_speed(value: float) -> void:
	max_linear_speed = value
	if spawner:
		spawner.set_max_linear_speed(value)


func set_max_linear_accel(value: float) -> void:
	max_linear_accel = value
	if spawner:
		spawner.set_max_linear_accel(value)


func set_proximity_radius(value: float) -> void:
	proximity_radius = value
	if spawner:
		spawner.set_proximity_radius(value)


func set_show_proximity_radius(value: bool) -> void:
	show_proximity_radius = value
	if spawner:
		spawner.set_show_proximity_radius(value)


func set_separation_decay_coef(value: float) -> void:
	separation_decay_coefficient = value
	if spawner:
		spawner.set_separation_decay_coef(value)


func set_cohesion_strength(value: float) -> void:
	cohesion_strength = value
	if spawner:
		spawner.set_cohesion_strength(value)


func set_separation_strength(value: float) -> void:
	separation_strength = value
	if spawner:
		spawner.set_separation_strength(value)
