extends KinematicBody2D


var draw_proximity: bool

var _boundary_right: float
var _boundary_bottom: float
var _radius: float
var _accel := GSTTargetAcceleration.new()
var _velocity := Vector2.ZERO
var _direction := Vector2()
var _drag := 0.1
var _color := Color(0.4, 1.0, 0.89, 0.3)

onready var collision := $CollisionShape2D
onready var agent := GSTSteeringAgent.new()
onready var proximity := GSTRadiusProximity.new(agent, [], 140)
onready var avoid := GSTAvoidCollisions.new(agent, proximity)
onready var target := GSTAgentLocation.new()
onready var seek := GSTSeek.new(agent, target)
onready var priority := GSTPriority.new(agent, 0.0001)


func _draw() -> void:
	if draw_proximity:
		draw_circle(Vector2.ZERO, proximity.radius, _color)


func _physics_process(delta: float) -> void:
	_update_agent()
	_accel = priority.calculate_steering(_accel)
	_velocity += Vector2(_accel.linear.x, _accel.linear.y)
	_velocity = _velocity.linear_interpolate(Vector2.ZERO, _drag)
	_velocity = _velocity.clamped(agent.linear_speed_max)
	_velocity = move_and_slide(_velocity)


func setup(
			linear_speed_max: float,
			linear_accel_max: float,
			proximity_radius: float,
			boundary_right: float,
			boundary_bottom: float,
			draw_proximity: bool,
			rng: RandomNumberGenerator
	) -> void:
	rng.randomize()
	_direction = Vector2(rng.randf_range(-1, 1), rng.randf_range(-1, 1)).normalized()
	_update_agent()
	agent.linear_speed_max = linear_speed_max
	agent.linear_acceleration_max = linear_accel_max
	proximity.radius = proximity_radius
	_boundary_bottom = boundary_bottom
	_boundary_right = boundary_right
	_radius = collision.shape.radius
	agent.bounding_radius = _radius
	
	self.draw_proximity = draw_proximity
	
	priority.add(avoid)
	priority.add(seek)


func set_proximity_agents(agents: Array) -> void:
	proximity.agents = agents


func set_random_nonoverlapping_position(others: Array, distance_from_boundary_min: float) -> void:
	var rng := RandomNumberGenerator.new()
	rng.randomize()
	var tries_max := max(100, others.size() * others.size())
	while tries_max > 0:
		tries_max -= 1
		global_position.x = rng.randf_range(
				distance_from_boundary_min, _boundary_right-distance_from_boundary_min
		)
		global_position.y = rng.randf_range(
				distance_from_boundary_min, _boundary_bottom-distance_from_boundary_min
		)
		var done := true
		for i in range(others.size()):
			var other: Node2D = others[i]
			if other.global_position.distance_to(position) <= _radius*2 + distance_from_boundary_min:
				done = false
		if done:
			break


func _update_agent() -> void:
	agent.position.x = global_position.x
	agent.position.y = global_position.y
	agent.linear_velocity.x = _velocity.x
	agent.linear_velocity.y = _velocity.y
	target.position.x = agent.position.x + _direction.x*_radius
	target.position.y = agent.position.y + _direction.y*_radius
