extends CharacterBody2D

var agent := await GSAICharacterBody2DAgent.new(self)
var target := GSAIAgentLocation.new()
var arrive := GSAIArrive.new(agent, target)
var _accel := GSAITargetAcceleration.new()

var _velocity := Vector2()
var _drag := 0.1

func _physics_process(delta: float) -> void:
	arrive.calculate_steering(_accel)
	agent._apply_steering(_accel, delta)


func setup(
	linear_speed_max: float,
	linear_acceleration_max: float,
	arrival_tolerance: float,
	deceleration_radius: float
) -> void:
	agent.linear_speed_max = linear_speed_max
	agent.linear_acceleration_max = linear_acceleration_max
	agent.linear_drag_percentage = _drag
	arrive.deceleration_radius = deceleration_radius
	arrive.arrival_tolerance = arrival_tolerance
	target.position = agent.position
