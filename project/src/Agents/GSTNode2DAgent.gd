# A specialized steering agent that updates itself every frame so the user does
# not have to.
extends GSTNodeAgent
class_name GSTNode2DAgent


# The Node2D to keep track of
var body: Node2D setget _set_body

var _last_position: Vector2


func _init(body: Node2D) -> void:
	self.body = body
	if body.is_inside_tree():
		body.get_tree().connect("physics_frame", self, "_on_SceneTree_frame")
	else:
		body.connect("ready", self, "_on_body_ready")


# Moves the agent's `body` by target `acceleration`.
# tags: virtual
func _apply_steering(acceleration: GSTTargetAcceleration, delta: float) -> void:
	_applied_steering = true
	match _body_type:
		BodyType.RIGID:
			_apply_rigid_steering(acceleration)
		BodyType.KINEMATIC:
			match kinematic_movement_type:
				MovementType.COLLIDE:
					_apply_collide_steering(acceleration.linear, delta)
				MovementType.SLIDE:
					_apply_sliding_steering(acceleration.linear)
				MovementType.POSITION:
					_apply_normal_steering(acceleration.linear, delta)
		BodyType.NODE:
			_apply_normal_steering(acceleration.linear, delta)
	if not _body_type == BodyType.RIGID:
		_apply_orientation_steering(acceleration.angular, delta)


func _apply_rigid_steering(accel: GSTTargetAcceleration) -> void:
	body.apply_central_impulse(GSTUtils.to_vector2(accel.linear))
	body.apply_torque_impulse(accel.angular)
	if calculate_velocities:
		linear_velocity = GSTUtils.to_vector3(body.linear_velocity)
		angular_velocity = body.angular_velocity


func _apply_sliding_steering(accel: Vector3) -> void:
	var velocity := GSTUtils.to_vector2(linear_velocity + accel).clamped(linear_speed_max)
	if apply_linear_drag:
		velocity = velocity.linear_interpolate(Vector2.ZERO, linear_drag_percentage)
	velocity = body.move_and_slide(velocity)
	if calculate_velocities:
		linear_velocity = GSTUtils.to_vector3(velocity)


func _apply_collide_steering(accel: Vector3, delta: float) -> void:
	var velocity := GSTUtils.clampedv3(linear_velocity + accel, linear_speed_max)
	if apply_linear_drag:
		velocity = velocity.linear_interpolate(
				Vector3.ZERO,
				linear_drag_percentage
		)
	body.move_and_collide(GSTUtils.to_vector2(velocity) * delta)
	if calculate_velocities:
		linear_velocity = velocity


func _apply_normal_steering(accel: Vector3, delta: float) -> void:
	var velocity := GSTUtils.clampedv3(linear_velocity + accel, linear_speed_max)
	if apply_linear_drag:
		velocity = velocity.linear_interpolate(
				Vector3.ZERO,
				linear_drag_percentage
		)
	body.global_position += GSTUtils.to_vector2(velocity) * delta
	if calculate_velocities:
		linear_velocity = velocity


func _apply_orientation_steering(angular_acceleration: float, delta: float) -> void:
	var velocity = angular_velocity + angular_acceleration
	if apply_angular_drag:
		velocity = lerp(velocity, 0, angular_drag_percentage)
	body.rotation += velocity * delta
	if calculate_velocities:
		angular_velocity = velocity


func _set_use_physics(value: bool) -> void:
	if use_physics and not value:
		body.get_tree().disconnect("idle_frame", self, "_on_SceneTree_frame")
		body.get_tree().connect("physics_frame", self, "_on_SceneTree_frame")
	elif not use_physics and value:
		body.get_tree().disconnect("physics_frame", self, "_on_SceneTree_frame")
		body.get_tree().connect("idle_frame", self, "_on_SceneTree_frame")
	use_physics = value


func _set_body(value: Node2D) -> void:
	body = value
	if body is RigidBody2D:
		_body_type = BodyType.RIGID
	elif body is KinematicBody2D:
		_body_type = BodyType.KINEMATIC
	else:
		_body_type = BodyType.NODE
	
	if _body_type == BodyType.RIGID:
		linear_velocity = GSTUtils.to_vector3(body.linear_velocity)
		angular_velocity = body.angular_velocity
	else:
		_last_position = body.global_position
		_last_orientation = body.rotation
	
	position = GSTUtils.to_vector3(_last_position)
	orientation = _last_orientation


func _on_body_ready() -> void:
	body.get_tree().connect("physics_frame", self, "_on_SceneTree_frame")
	_set_body(body)


func _on_SceneTree_frame() -> void:
	var current_position: Vector2 = body.global_position
	var current_orientation: float = body.rotation
	
	position = GSTUtils.to_vector3(current_position)
	orientation = current_orientation
	
	if calculate_velocities:
		if _applied_steering:
			_applied_steering = false
		else:
			match _body_type:
				BodyType.RIGID:
					linear_velocity = GSTUtils.to_vector3(body.linear_velocity)
					angular_velocity = body.angular_velocity
				_:
					linear_velocity = GSTUtils.clampedv3(
							GSTUtils.to_vector3(_last_position - current_position),
							linear_speed_max
					)
					if apply_linear_drag:
						linear_velocity = linear_velocity.linear_interpolate(
								Vector3.ZERO,
								linear_drag_percentage
						)
					angular_velocity = clamp(
							_last_orientation - current_orientation,
							-angular_speed_max,
							angular_speed_max
					)
					if apply_angular_drag:
						angular_velocity = lerp(
								angular_velocity,
								0,
								angular_drag_percentage
						)
			
			_last_position = current_position
			_last_orientation = current_orientation
