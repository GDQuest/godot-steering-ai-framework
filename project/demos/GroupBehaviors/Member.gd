extends KinematicBody2D


var separation: GSTSeparation
var cohesion: GSTCohesion
var proximity: GSTRadiusProximity
var agent := GSTSteeringAgent.new()
var blend := GSTBlend.new(agent)
var acceleration := GSTTargetAcceleration.new()
var draw_proximity := false

var _color := Color.red
var _velocity := Vector2()


func setup(
		max_linear_speed: float,
		max_linear_accel: float,
		proximity_radius: float,
		separation_decay_coefficient: float,
		cohesion_strength: float,
		separation_strength: float
	) -> void:
	_color = Color(rand_range(0.5, 1), rand_range(0.25, 1), rand_range(0, 1))
	$Sprite.modulate = _color
	
	agent.max_linear_acceleration = max_linear_accel
	agent.max_linear_speed = max_linear_speed
	
	proximity = GSTRadiusProximity.new(agent, [], proximity_radius)
	separation = GSTSeparation.new(agent, proximity)
	separation.decay_coefficient = separation_decay_coefficient
	cohesion = GSTCohesion.new(agent, proximity)
	blend.add(separation, separation_strength)
	blend.add(cohesion, cohesion_strength)


func _draw() -> void:
	if draw_proximity:
		draw_circle(Vector2.ZERO, proximity.radius, Color(0, 1, 0, 0.1))


func _physics_process(delta: float) -> void:
	agent.position.x = global_position.x
	agent.position.y = global_position.y
	if blend:
		acceleration = blend.calculate_steering(acceleration)
		_velocity += Vector2(acceleration.linear.x, acceleration.linear.y)
		_velocity = _velocity.linear_interpolate(Vector2.ZERO, 0.1)
		_velocity = _velocity.clamped(agent.max_linear_speed)
		move_and_slide(_velocity)


func set_neighbors(neighbor: Array) -> void:
	proximity.agents = neighbor
