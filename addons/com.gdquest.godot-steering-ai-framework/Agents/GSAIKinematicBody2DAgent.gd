# A specialized steering agent that updates itself every frame so the user does
# not have to using a KinematicBody2D
# @category - Specialized agents
extends GSAISpecializedAgent
class_name GSAIKinematicBody2DAgent

# SLIDE uses `move_and_slide`
# COLLIDE uses `move_and_collide`
# POSITION changes the `global_position` directly
enum MovementType { SLIDE, COLLIDE, POSITION }

# The KinematicBody2D to keep track of
var body: KinematicBody2D setget _set_body

# The type of movement the body executes
var movement_type: int

var _last_position: Vector2
var _body_ref: WeakRef


func _init(_body: KinematicBody2D, _movement_type: int = MovementType.SLIDE) -> void:
	if not _body.is_inside_tree():
		yield(_body, "ready")

	self.body = _body
	self.movement_type = _movement_type

	# warning-ignore:return_value_discarded
	_body.get_tree().connect("physics_frame", self, "_on_SceneTree_physics_frame")


# Moves the agent's `body` by target `acceleration`.
# @tags - virtual
func _apply_steering(acceleration: GSAITargetAcceleration, delta: float) -> void:
	_applied_steering = true
	match movement_type:
		MovementType.COLLIDE:
			_apply_collide_steering(acceleration.linear, delta)
		MovementType.SLIDE:
			_apply_sliding_steering(acceleration.linear, delta)
		_:
			_apply_position_steering(acceleration.linear, delta)

	_apply_orientation_steering(acceleration.angular, delta)


func _apply_sliding_steering(accel: Vector3, delta: float) -> void:
	var _body: KinematicBody2D = _body_ref.get_ref()
	if not _body:
		return
		
	var velocity := GSAIUtils.to_vector2(linear_velocity + accel * delta).clamped(linear_speed_max)
	if apply_linear_drag:
		velocity = velocity.linear_interpolate(Vector2.ZERO, linear_drag_percentage)
	velocity = _body.move_and_slide(velocity)
	if calculate_velocities:
		linear_velocity = GSAIUtils.to_vector3(velocity)


func _apply_collide_steering(accel: Vector3, delta: float) -> void:
	var _body: KinematicBody2D = _body_ref.get_ref()
	if not _body:
		return
		
	var velocity := GSAIUtils.clampedv3(linear_velocity + accel * delta, linear_speed_max)
	if apply_linear_drag:
		velocity = velocity.linear_interpolate(Vector3.ZERO, linear_drag_percentage)
	# warning-ignore:return_value_discarded
	_body.move_and_collide(GSAIUtils.to_vector2(velocity) * delta)
	if calculate_velocities:
		linear_velocity = velocity


func _apply_position_steering(accel: Vector3, delta: float) -> void:
	var _body: KinematicBody2D = _body_ref.get_ref()
	if not _body:
		return
		
	var velocity := GSAIUtils.clampedv3(linear_velocity + accel * delta, linear_speed_max)
	if apply_linear_drag:
		velocity = velocity.linear_interpolate(Vector3.ZERO, linear_drag_percentage)
	_body.global_position += GSAIUtils.to_vector2(velocity) * delta
	if calculate_velocities:
		linear_velocity = velocity


func _apply_orientation_steering(angular_acceleration: float, delta: float) -> void:
	var _body: KinematicBody2D = _body_ref.get_ref()
	if not _body:
		return
		
	var velocity = clamp(
		angular_velocity + angular_acceleration * delta,
		-angular_acceleration_max,
		angular_acceleration_max
	)
	if apply_angular_drag:
		velocity = lerp(velocity, 0, angular_drag_percentage)
	_body.rotation += velocity * delta
	if calculate_velocities:
		angular_velocity = velocity


func _set_body(value: KinematicBody2D) -> void:
	body = value
	_body_ref = weakref(body)

	_last_position = value.global_position
	_last_orientation = value.rotation

	position = GSAIUtils.to_vector3(_last_position)
	orientation = _last_orientation


func _on_SceneTree_physics_frame() -> void:
	var _body: KinematicBody2D = _body_ref.get_ref()
	if not _body:
		return
	
	var current_position := _body.global_position
	var current_orientation := _body.rotation

	position = GSAIUtils.to_vector3(current_position)
	orientation = current_orientation

	if calculate_velocities:
		if _applied_steering:
			_applied_steering = false
		else:
			linear_velocity = GSAIUtils.clampedv3(
				GSAIUtils.to_vector3(current_position - _last_position), linear_speed_max
			)
			if apply_linear_drag:
				linear_velocity = linear_velocity.linear_interpolate(
					Vector3.ZERO, linear_drag_percentage
				)

			angular_velocity = clamp(
				_last_orientation - current_orientation, -angular_speed_max, angular_speed_max
			)

			if apply_angular_drag:
				angular_velocity = lerp(angular_velocity, 0, angular_drag_percentage)

			_last_position = current_position
			_last_orientation = current_orientation
