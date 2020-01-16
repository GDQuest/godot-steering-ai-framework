extends KinematicBody2D
# Represents a ship that chases after the player.


onready var agent := GSTSteeringAgent.new()
onready var accel := GSTTargetAcceleration.new()
onready var player_agent: GSTSteeringAgent = owner.find_node("Player", true, false).agent

export var use_seek: bool = false

var _orient_behavior: GSTSteeringBehavior
var _behavior: GSTSteeringBehavior

var _linear_velocity := Vector2()
var _linear_drag_coefficient := 0.025
var _angular_velocity := 0.0
var _angular_drag := 0.1


func _ready() -> void:
	set_physics_process(false)


func _physics_process(delta: float) -> void:
	_update_agent()
	
	accel = _orient_behavior.calculate_steering(accel)
	_angular_velocity += accel.angular
	
	_angular_velocity = clamp(
			lerp(_angular_velocity, 0, _angular_drag),
			-agent.max_angular_speed,
			agent.max_angular_speed
	)
	
	rotation += _angular_velocity * delta
	
	accel = _behavior.calculate_steering(accel)
	_linear_velocity += Vector2(accel.linear.x, accel.linear.y)
	_linear_velocity = _linear_velocity.linear_interpolate(Vector2.ZERO, _linear_drag_coefficient)
	_linear_velocity = _linear_velocity.clamped(agent.max_linear_speed)
	_linear_velocity = move_and_slide(_linear_velocity)


func setup(predict_time: float, max_linear_speed: float, max_linear_accel: float) -> void:
	if use_seek:
		_behavior = GSTSeek.new(agent, player_agent)
	else:
		_behavior = GSTPursue.new(agent, player_agent, predict_time)
	
	_orient_behavior = GSTLookWhereYouGo.new(agent)
	_orient_behavior.alignment_tolerance = 0.001
	_orient_behavior.deceleration_radius = PI/2
	
	agent.max_angular_acceleration = 2
	agent.max_angular_speed = 5
	agent.max_linear_acceleration = max_linear_accel
	agent.max_linear_speed = max_linear_speed
	
	_update_agent()
	set_physics_process(true)


func _update_agent() -> void:
	agent.position.x = global_position.x
	agent.position.y = global_position.y
	agent.orientation = rotation
	agent.linear_velocity.x = _linear_velocity.x
	agent.linear_velocity.y = _linear_velocity.y
	agent.angular_velocity = _angular_velocity
