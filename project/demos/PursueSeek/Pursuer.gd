extends KinematicBody2D
# Represents a ship that chases after the player.


export var use_seek: bool = false

var _orient_behavior: GSTSteeringBehavior
var _behavior: GSTSteeringBehavior

var _linear_velocity := Vector2()
var _linear_drag_coefficient := 0.025
var _angular_velocity := 0.0
var _angular_drag := 0.1
var _direction_face := GSTAgentLocation.new()

onready var agent := GSTSteeringAgent.new()
onready var accel := GSTTargetAcceleration.new()
onready var player_agent: GSTSteeringAgent = owner.find_node("Player", true, false).agent


func _ready() -> void:
	set_physics_process(false)


func _physics_process(delta: float) -> void:
	_update_agent()
	
	accel = _behavior.calculate_steering(accel)
	
	_direction_face.position = agent.position + accel.linear.normalized()
	
	accel = _orient_behavior.calculate_steering(accel)
	_angular_velocity += accel.angular
	
	_angular_velocity = clamp(
			lerp(_angular_velocity, 0, _angular_drag),
			-agent.angular_speed_max,
			agent.angular_speed_max
	)
	
	rotation += _angular_velocity * delta
	
	_linear_velocity += GSTUtils.angle_to_vector2(rotation) * -agent.linear_acceleration_max
	_linear_velocity = _linear_velocity.clamped(agent.linear_speed_max)
	_linear_velocity = _linear_velocity.linear_interpolate(Vector2.ZERO, _linear_drag_coefficient)
	_linear_velocity = move_and_slide(_linear_velocity)


func setup(predict_time: float, linear_speed_max: float, linear_accel_max: float) -> void:
	if use_seek:
		_behavior = GSTSeek.new(agent, player_agent)
	else:
		_behavior = GSTPursue.new(agent, player_agent, predict_time)
	
	_orient_behavior = GSTFace.new(agent, _direction_face)
	_orient_behavior.alignment_tolerance = deg2rad(5)
	_orient_behavior.deceleration_radius = deg2rad(5)
	
	agent.angular_acceleration_max = deg2rad(40)
	agent.angular_speed_max = deg2rad(90)
	agent.linear_acceleration_max = linear_accel_max
	agent.linear_speed_max = linear_speed_max
	
	_update_agent()
	set_physics_process(true)


func _update_agent() -> void:
	agent.position.x = global_position.x
	agent.position.y = global_position.y
	agent.orientation = rotation
	agent.linear_velocity.x = _linear_velocity.x
	agent.linear_velocity.y = _linear_velocity.y
	agent.angular_velocity = _angular_velocity
