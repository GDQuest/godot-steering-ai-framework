extends KinematicBody2D


var _velocity := Vector2.ZERO
var _accel := GSTTargetAcceleration.new()
var _valid := false
var _drag := 0.1

onready var agent := GSTSteeringAgent.new()
onready var path := GSTPath.new([
		Vector3(global_position.x, global_position.y, 0),
		Vector3(global_position.x, global_position.y, 0)
	], true)
onready var follow := GSTFollowPath.new(agent, path, 0, 0)


func setup(
			path_offset: float,
			predict_time: float,
			accel_max: float,
			speed_max: float,
			decel_radius: float,
			arrival_tolerance: float
	) -> void:
	owner.drawer.connect("path_established", self, "_on_Drawer_path_established")
	follow.path_offset = path_offset
	follow.prediction_time = predict_time
	agent.linear_acceleration_max = accel_max
	agent.linear_speed_max = speed_max
	follow.deceleration_radius = decel_radius
	follow.arrival_tolerance = arrival_tolerance


func _physics_process(delta: float) -> void:
	if _valid:
		_update_agent()
		follow.calculate_steering(_accel)
		_velocity += Vector2(_accel.linear.x, _accel.linear.y)
		_velocity = _velocity.linear_interpolate(Vector2.ZERO, _drag)
		_velocity = _velocity.clamped(agent.linear_speed_max)
		_velocity = move_and_slide(_velocity)


func _update_agent() -> void:
	agent.position.x = global_position.x
	agent.position.y = global_position.y
	agent.linear_velocity.x = _velocity.x
	agent.linear_velocity.y = _velocity.y


func _on_Drawer_path_established(points: Array) -> void:
	var points3 := []
	for p in points:
		points3.append(Vector3(p.x, p.y, 0))
	path.create_path(points3)
	_valid = true
