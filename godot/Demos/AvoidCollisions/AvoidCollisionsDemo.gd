extends Node

export (float, 0, 1000, 40) var linear_speed_max := 350.0 setget set_linear_speed_max
export (float, 0, 4000, 2) var linear_acceleration_max := 40.0 setget set_linear_accel_max
export (float, 0, 500, 10) var proximity_radius := 140.0 setget set_proximity_radius
export var draw_proximity := true setget set_draw_proximity

onready var spawner := $Spawner


func set_linear_speed_max(value: float) -> void:
	linear_speed_max = value
	if not is_inside_tree():
		return

	spawner.set_linear_speed_max(value)


func set_linear_accel_max(value: float) -> void:
	linear_acceleration_max = value
	if not is_inside_tree():
		return

	spawner.set_linear_accel_max(value)


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
