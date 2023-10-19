extends CharacterBody3D

var target_node: Node3D

@onready var agent := await GSAICharacterBody3DAgent.new(self)
@onready var target := GSAIAgentLocation.new()
@onready var accel := GSAITargetAcceleration.new()
@onready var blend := GSAIBlend.new(agent)
@onready var face := GSAIFace.new(agent, target, true)
@onready var arrive := GSAIArrive.new(agent, target)


func _physics_process(delta: float) -> void:
	target.position = target_node.transform.origin
	target.position.y = transform.origin.y
	blend.calculate_steering(accel)
	agent._apply_steering(accel, delta)


func setup(
	align_tolerance: float,
	angular_deceleration_radius: float,
	angular_accel_max: float,
	angular_speed_max: float,
	deceleration_radius: float,
	arrival_tolerance: float,
	linear_acceleration_max: float,
	linear_speed_max: float,
	_target: Node3D
) -> void:
	agent.linear_speed_max = linear_speed_max
	agent.linear_acceleration_max = linear_acceleration_max
	agent.linear_drag_percentage = 0.05
	agent.angular_acceleration_max = angular_accel_max
	agent.angular_speed_max = angular_speed_max
	agent.angular_drag_percentage = 0.1

	arrive.arrival_tolerance = arrival_tolerance
	arrive.deceleration_radius = deceleration_radius

	face.alignment_tolerance = align_tolerance
	face.deceleration_radius = angular_deceleration_radius

	target_node = _target
	self.target.position = target_node.transform.origin
	blend.add(arrive, 1)
	blend.add(face, 1)
