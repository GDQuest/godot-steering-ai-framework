extends CharacterBody2D

var draw_proximity: bool

var _boundary_right: float
var _boundary_bottom: float
var _radius: float
var _accel := GSAITargetAcceleration.new()
var _velocity := Vector2.ZERO
var _direction := Vector2()
var _drag := 0.1
var _color := Color(0.4, 1.0, 0.89, 0.3)

@onready var collision := $CollisionShape2D
@onready var agent := await GSAICharacterBody2DAgent.new(self)
@onready var proximity := GSAIRadiusProximity.new(agent, [], 140)
@onready var avoid := GSAIAvoidCollisions.new(agent, proximity)
@onready var target := GSAIAgentLocation.new()
@onready var seek := GSAISeek.new(agent, target)
@onready var priority := GSAIPriority.new(agent, 0.0001)


func _draw() -> void:
	if draw_proximity:
		draw_circle(Vector2.ZERO, proximity.radius, _color)


func _physics_process(delta: float) -> void:
	target.position.x = agent.position.x + _direction.x * _radius
	target.position.y = agent.position.y + _direction.y * _radius

	priority.calculate_steering(_accel)
	agent._apply_steering(_accel, delta)


func setup(
	linear_speed_max: float,
	linear_accel_max: float,
	proximity_radius: float,
	boundary_right: float,
	boundary_bottom: float,
	_draw_proximity: bool,
	rng: RandomNumberGenerator
) -> void:
	rng.randomize()
	_direction = Vector2(rng.randf_range(-1, 1), rng.randf_range(-1, 1)).normalized()

	agent.linear_speed_max = linear_speed_max
	agent.linear_acceleration_max = linear_accel_max

	proximity.radius = proximity_radius
	_boundary_bottom = boundary_bottom
	_boundary_right = boundary_right

	_radius = collision.shape.radius
	agent.bounding_radius = _radius

	agent.linear_drag_percentage = _drag

	self.draw_proximity = _draw_proximity

	priority.add(avoid)
	priority.add(seek)


func set_proximity_agents(agents: Array) -> void:
	proximity.agents = agents


func set_random_nonoverlapping_position(others: Array, distance_from_boundary_min: float) -> void:
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	var tries_max : int = max(100, others.size() * others.size())
	while tries_max > 0:
		tries_max -= 1
		global_position.x = rng.randf_range(
			distance_from_boundary_min, _boundary_right - distance_from_boundary_min
		)
		global_position.y = rng.randf_range(
			distance_from_boundary_min, _boundary_bottom - distance_from_boundary_min
		)
		var done := true
		for i in range(others.size()):
			var other: Node2D = others[i]
			if (
				other.global_position.distance_to(position)
				<= _radius * 2 + distance_from_boundary_min
			):
				done = false
		if done:
			break
