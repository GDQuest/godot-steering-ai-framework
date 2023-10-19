extends CharacterBody2D
# Represents a ship that chases after the player.

@export var use_seek: bool = false

var _blend: GSAIBlend

var _linear_drag_coefficient := 0.025
var _angular_drag := 0.1
var _direction_face := GSAIAgentLocation.new()

@onready var agent := await GSAICharacterBody2DAgent.new(self)
@onready var accel := GSAITargetAcceleration.new()
@onready var player_agent: GSAISteeringAgent = owner.find_child("Player", true, false).agent


func _ready() -> void:
	agent.calculate_velocities = false
	set_physics_process(false)


func _physics_process(delta: float) -> void:
	_direction_face.position = agent.position + accel.linear.normalized()

	_blend.calculate_steering(accel)

	agent.angular_velocity = clamp(
		agent.angular_velocity + accel.angular * delta, -agent.angular_speed_max, agent.angular_speed_max
	)
	agent.angular_velocity = lerp(agent.angular_velocity, 0.0, _angular_drag)

	rotation += agent.angular_velocity * delta

	var linear_velocity := (
		GSAIUtils.to_vector2(agent.linear_velocity)
		+ (GSAIUtils.angle_to_vector2(rotation) * -agent.linear_acceleration_max * delta)
	)
	linear_velocity = linear_velocity.limit_length(agent.linear_speed_max)
	linear_velocity = linear_velocity.lerp(Vector2.ZERO, _linear_drag_coefficient)

	set_velocity(linear_velocity)
	move_and_slide()
	linear_velocity = velocity
	agent.linear_velocity = GSAIUtils.to_vector3(linear_velocity)


func setup(predict_time: float, linear_speed_max: float, linear_accel_max: float) -> void:
	var behavior: GSAISteeringBehavior
	if use_seek:
		behavior = GSAISeek.new(agent, player_agent)
	else:
		behavior = GSAIPursue.new(agent, player_agent, predict_time)

	var orient_behavior := GSAIFace.new(agent, _direction_face)
	orient_behavior.alignment_tolerance = deg_to_rad(5)
	orient_behavior.deceleration_radius = deg_to_rad(30)

	_blend = GSAIBlend.new(agent)
	_blend.add(behavior, 1)
	_blend.add(orient_behavior, 1)

	agent.angular_acceleration_max = deg_to_rad(1080)
	agent.angular_speed_max = deg_to_rad(360)
	agent.linear_acceleration_max = linear_accel_max
	agent.linear_speed_max = linear_speed_max

	set_physics_process(true)
