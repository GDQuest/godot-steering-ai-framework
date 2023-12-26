extends CharacterBody2D

var separation: GSAISeparation
var cohesion: GSAICohesion
var proximity: GSAIRadiusProximity
var agent := await GSAICharacterBody2DAgent.new(self)
var blend := GSAIBlend.new(agent)
var acceleration := GSAITargetAcceleration.new()
var draw_proximity := false

var _color := Color.RED
var _velocity := Vector2()

@onready var collision_shape := $CollisionShape2D


func setup(
	linear_speed_max: float,
	linear_accel_max: float,
	proximity_radius: float,
	separation_decay_coefficient: float,
	cohesion_strength: float,
	separation_strength: float
) -> void:
	_color = Color(randf_range(0.5, 1), randf_range(0.25, 1), randf_range(0, 1))
	collision_shape.inner_color = _color

	agent.linear_acceleration_max = linear_accel_max
	agent.linear_speed_max = linear_speed_max
	agent.linear_drag_percentage = 0.1

	proximity = GSAIRadiusProximity.new(agent, [], proximity_radius)
	separation = GSAISeparation.new(agent, proximity)
	separation.decay_coefficient = separation_decay_coefficient
	cohesion = GSAICohesion.new(agent, proximity)
	blend.add(separation, separation_strength)
	blend.add(cohesion, cohesion_strength)


func _draw() -> void:
	if draw_proximity:
		draw_circle(Vector2.ZERO, proximity.radius, Color(0.4, 1.0, 0.89, 0.3))


func _physics_process(delta: float) -> void:
	if blend:
		blend.calculate_steering(acceleration)
		agent._apply_steering(acceleration, delta)


func set_neighbors(neighbor: Array) -> void:
	proximity.agents = neighbor
