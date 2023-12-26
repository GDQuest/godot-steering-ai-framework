extends Node

@export_range(0, 1000, 40) var linear_speed_max := 350.0: set = set_linear_speed_max
@export_range(0, 4000, 2) var linear_acceleration_max := 40.0: set = set_linear_accel_max
@export_range(0, 500, 10) var proximity_radius := 140.0: set = set_proximity_radius
@export var draw_proximity := true: set = set_draw_proximity

@onready var spawner := $Spawner


func _ready():
	get_tree().root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	get_tree().root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_EXPAND

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
