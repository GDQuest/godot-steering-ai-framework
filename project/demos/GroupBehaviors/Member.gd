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
		linear_speed_max: float,
		linear_accel_max: float,
		proximity_radius: float,
		separation_decay_coefficient: float,
		cohesion_strength: float,
		separation_strength: float
	) -> void:
	_color = Color(rand_range(0.5, 1), rand_range(0.25, 1), rand_range(0, 1))
	$Sprite.modulate = _color
	
	agent.linear_acceleration_max = linear_accel_max
	agent.linear_speed_max = linear_speed_max
	
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
		_velocity = _velocity.clamped(agent.linear_speed_max)
		move_and_slide(_velocity)


func set_neighbors(neighbor: Array) -> void:
	proximity.agents = neighbor
