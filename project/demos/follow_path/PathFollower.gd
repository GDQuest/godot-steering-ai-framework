extends KinematicBody2D


onready var agent: = GSTSteeringAgent.new()
onready var path: = GSTPath.new([
		Vector3(global_position.x, global_position.y, 0),
		Vector3(global_position.x, global_position.y, 0)
	], true)
onready var follow: = GSTFollowPath.new(agent, path, 20, 0)

var _velocity: = Vector2.ZERO
var _accel: = GSTTargetAcceleration.new()
var _valid: = false


func setup() -> void:
	owner.drawer.connect("path_established", self, "_on_Drawer_path_established")
	agent.max_linear_acceleration = 20
	agent.max_linear_speed = 200


func _physics_process(delta: float) -> void:
	if _valid:
		_update_agent()
		_accel = follow.calculate_steering(_accel)
		_velocity += Vector2(_accel.linear.x, _accel.linear.y)
		_velocity = _velocity.clamped(agent.max_linear_speed)
		_velocity = move_and_slide(_velocity)


func _update_agent() -> void:
	agent.position.x = global_position.x
	agent.position.y = global_position.y
	agent.linear_velocity.x = _velocity.x
	agent.linear_velocity.y = _velocity.y


func _on_Drawer_path_established(points: Array) -> void:
	var points3: = []
	for p in points:
		points3.append(Vector3(p.x, p.y, 0))
	path.create_path(points3)
	_valid = true
