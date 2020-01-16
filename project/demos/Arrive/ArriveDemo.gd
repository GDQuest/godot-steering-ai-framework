extends Node2D


export(float, 0, 2000, 40) var max_linear_speed := 800.0 setget set_max_linear_speed
export(float, 0, 200, 2.0) var max_linear_acceleration := 80.0 setget set_max_linear_acceleration
export(float, 0, 100, 0.1) var arrival_tolerance := 25.0 setget set_arrival_tolerance
export(float, 0, 500, 10) var deceleration_radius := 125.0 setget set_deceleration_radius

const COLORS := {
	deceleration_radius = Color(0.9, 1, 0, 0.1),
	arrival_tolerance = Color(0.5, 0.7, 0.9, 0.2)
}

onready var arriver := $Arriver


func _ready() -> void:
	arriver.setup(
		max_linear_speed,
		max_linear_acceleration,
		arrival_tolerance,
		deceleration_radius
	)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseButton and event.button_index == BUTTON_LEFT and event.is_pressed():
		arriver.target.position = Vector3(event.position.x, event.position.y, 0)
		update()


func _draw():
	var target_position := Vector2(arriver.target.position.x, arriver.target.position.y)
	draw_circle(target_position, deceleration_radius, COLORS.deceleration_radius)
	draw_circle(target_position, arrival_tolerance, COLORS.arrival_tolerance)


func set_arrival_tolerance(value: float) -> void:
	arrival_tolerance = value
	if not is_inside_tree():
		return
	
	arriver.arrive.arrival_tolerance = value


func set_deceleration_radius(value: float) -> void:
	deceleration_radius = value
	if not is_inside_tree():
		return
	
	arriver.arrive.deceleration_radius = value


func set_max_linear_speed(value: float) -> void:
	max_linear_speed = value
	if not is_inside_tree():
		return
	
	arriver.agent.max_linear_speed = value


func set_max_linear_acceleration(value: float) -> void:
	max_linear_acceleration = value
	if not is_inside_tree():
		return
	
	arriver.agent.max_linear_acceleration = value
