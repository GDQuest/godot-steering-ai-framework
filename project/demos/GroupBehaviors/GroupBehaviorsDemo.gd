extends Node2D


onready var spawner := $Spawner

export var max_linear_speed := 100.0 setget set_max_linear_speed
export var max_linear_accel := 25.0 setget set_max_linear_accel
export var proximity_radius := 140.0 setget set_proximity_radius
export var separation_decay_coefficient := 2000.0 setget set_separation_decay_coef
export var cohesion_strength := 0.3 setget set_cohesion_strength
export var separation_strength := 1.5 setget set_separation_strength
export var show_proximity_radius := true setget set_show_proximity_radius


func _ready() -> void:
	spawner.setup(
		max_linear_speed,
		max_linear_accel,
		proximity_radius,
		separation_decay_coefficient,
		cohesion_strength,
		separation_strength,
		show_proximity_radius
	)


func set_max_linear_speed(value: float) -> void:
	if not is_inside_tree():
		return
	
	max_linear_speed = value
	spawner.set_max_linear_speed(value)


func set_max_linear_accel(value: float) -> void:
	if not is_inside_tree():
		return
	
	max_linear_accel = value
	spawner.set_max_linear_accel(value)


func set_proximity_radius(value: float) -> void:
	if not is_inside_tree():
		return
	
	proximity_radius = value
	spawner.set_proximity_radius(value)


func set_show_proximity_radius(value: bool) -> void:
	if not is_inside_tree():
		return
	
	show_proximity_radius = value
	spawner.set_show_proximity_radius(value)


func set_separation_decay_coef(value: float) -> void:
	if not is_inside_tree():
		return
	
	separation_decay_coefficient = value
	spawner.set_separation_decay_coef(value)


func set_cohesion_strength(value: float) -> void:
	if not is_inside_tree():
		return
	
	cohesion_strength = value
	spawner.set_cohesion_strength(value)


func set_separation_strength(value: float) -> void:
	if not is_inside_tree():
		return
	
	separation_strength = value
	spawner.set_separation_strength(value)
