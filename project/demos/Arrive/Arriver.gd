extends KinematicBody2D


var agent := GSTSteeringAgent.new()
var target := GSTAgentLocation.new()
var arrive := GSTArrive.new(agent, target)
var _accel := GSTTargetAcceleration.new()

var _velocity := Vector2()
var _drag := 0.1


func _physics_process(delta: float) -> void:
	_update_agent()
	_accel = arrive.calculate_steering(_accel)
	_velocity += Vector2(_accel.linear.x, _accel.linear.y)
	_velocity = _velocity.linear_interpolate(Vector2.ZERO, _drag).clamped(agent.max_linear_speed)
	_velocity = move_and_slide(_velocity)


func setup(
	max_linear_speed: float,
	max_linear_acceleration: float,
	arrival_tolerance: float,
	deceleration_radius: float
) -> void:
	agent.max_linear_speed = max_linear_speed
	agent.max_linear_acceleration = max_linear_acceleration
	agent.position = Vector3(global_position.x, global_position.y, 0)
	arrive.deceleration_radius = deceleration_radius
	arrive.arrival_tolerance = arrival_tolerance
	target.position = agent.position


func _update_agent() -> void:
	agent.position = Vector3(global_position.x, global_position.y, 0)
	agent.linear_velocity = Vector3(_velocity.x, _velocity.y, 0)
