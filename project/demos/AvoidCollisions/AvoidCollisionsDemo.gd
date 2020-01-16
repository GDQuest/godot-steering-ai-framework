extends Node2D


export(float, 0, 2000, 40) var max_linear_speed := 350.0 setget set_max_linear_speed
export(float, 0, 100, 2) var max_linear_acceleration := 40.0 setget set_max_linear_accel
export(float, 0, 500, 10) var proximity_radius := 140.0 setget set_proximity_radius
export var draw_proximity := true setget set_draw_proximity

onready var spawner := $Spawner


func set_max_linear_speed(value: float) -> void:
	max_linear_speed = value
	if not is_inside_tree():
		return
	
	spawner.set_max_linear_speed(value)


func set_max_linear_accel(value: float) -> void:
	max_linear_acceleration = value
	if not is_inside_tree():
		return
	
	spawner.set_max_linear_accel(value)


func set_proximity_radius(value: float) -> void:
	proximity_radius = value
	if not is_inside_tree():
		return
	
	spawner.set_proximity_radius(value)


func set_draw_proximity(value: bool) -> void:
	draw_proximity = value
	if not is_inside_tree():
		return
	
	spawner.set_draw_proximity(value)
