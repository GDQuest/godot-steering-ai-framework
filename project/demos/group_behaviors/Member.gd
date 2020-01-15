extends KinematicBody2D


var agent: = GSTSteeringAgent.new()
var separation: GSTSeparation
var cohesion: GSTCohesion
var proximity: GSTRadiusProximity
var blend: = GSTBlend.new(agent)
var acceleration: = GSTTargetAcceleration.new()

var _radius: float
var _color: = Color.red
var _velocity: = Vector2()

onready var shape: = $CollisionShape2D


func _ready() -> void:
	_radius = shape.shape.radius
	_color = Color(rand_range(0.5, 1), rand_range(0.25, 1), rand_range(0, 1))
	agent.max_linear_acceleration = 7
	agent.max_linear_speed = 70
	
	proximity = GSTRadiusProximity.new(agent, [], 140)
	separation = GSTSeparation.new(agent, proximity)
	separation.decay_coefficient = 2000
	cohesion = GSTCohesion.new(agent, proximity)
	blend.add(separation, 1.5)
	blend.add(cohesion, 0.3)


func _draw() -> void:
	draw_circle(Vector2.ZERO, _radius, _color)


func _process(delta: float) -> void:
	update_agent()
	if blend:
		acceleration = blend.calculate_steering(acceleration)
		_velocity = (_velocity + Vector2(acceleration.linear.x, acceleration.linear.y)).clamped(agent.max_linear_speed)
		move_and_slide(_velocity)


func set_neighbors(neighbor: Array) -> void:
	proximity.agents = neighbor


func update_agent() -> void:
	var current_position: = global_position
	agent.position.x = current_position.x
	agent.position.y = current_position.y
