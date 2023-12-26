extends Node

@onready var spawner := $Spawner

@export_range(0, 2000, 40.0) var linear_speed_max := 600.0: set = set_linear_speed_max
@export_range(0, 9000, 2.0) var linear_accel_max := 40.0: set = set_linear_accel_max
@export_range(0, 300, 2.0) var proximity_radius := 140.0: set = set_proximity_radius
@export_range(0, 200000, 250) var separation_decay_coefficient := 2000.0: set = set_separation_decay_coef
@export_range(0, 2, 0.1) var cohesion_strength := 0.1: set = set_cohesion_strength
@export_range(0, 10, 0.2) var separation_strength := 1.5: set = set_separation_strength
@export var show_proximity_radius := true: set = set_show_proximity_radius


func _ready() -> void:
	get_tree().root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	get_tree().root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_EXPAND
	
	spawner.setup(
		linear_speed_max,
		linear_accel_max,
		proximity_radius,
		separation_decay_coefficient,
		cohesion_strength,
		separation_strength,
		show_proximity_radius
	)


func set_linear_speed_max(value: float) -> void:
	linear_speed_max = value
	if not is_inside_tree():
		return

	spawner.set_linear_speed_max(value)


func set_linear_accel_max(value: float) -> void:
	linear_accel_max = value
	if not is_inside_tree():
		return

	spawner.set_linear_accel_max(value)


func set_proximity_radius(value: float) -> void:
	proximity_radius = value
	if not is_inside_tree():
		return

	spawner.set_proximity_radius(value)


func set_show_proximity_radius(value: bool) -> void:
	show_proximity_radius = value
	if not is_inside_tree():
		return

	spawner.set_show_proximity_radius(value)


func set_separation_decay_coef(value: float) -> void:
	separation_decay_coefficient = value
	if not is_inside_tree():
		return

	spawner.set_separation_decay_coef(value)


func set_cohesion_strength(value: float) -> void:
	cohesion_strength = value
	if not is_inside_tree():
		return

	spawner.set_cohesion_strength(value)


func set_separation_strength(value: float) -> void:
	separation_strength = value
	if not is_inside_tree():
		return

	spawner.set_separation_strength(value)
