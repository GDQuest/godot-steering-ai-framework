# A specialized steering agent that updates itself every frame so the user does
# not have to using a RigidBody2D
# @category - Specialized agents
extends GSAISpecializedAgent
class_name GSAIRigidBody2DAgent

# The RigidBody2D to keep track of
var body: RigidBody2D setget _set_body

var _last_position: Vector2
var _body_ref: WeakRef


func _init(_body: RigidBody2D) -> void:
	if not _body.is_inside_tree():
		yield(_body, "ready")
	self.body = _body

	# warning-ignore:return_value_discarded
	_body.get_tree().connect("physics_frame", self, "_on_SceneTree_frame")


# Moves the agent's `body` by target `acceleration`.
# @tags - virtual
func _apply_steering(acceleration: GSAITargetAcceleration, _delta: float) -> void:
	var _body: RigidBody2D = _body_ref.get_ref()
	if not _body:
		return

	_applied_steering = true
	_body.apply_central_impulse(GSAIUtils.to_vector2(acceleration.linear))
	_body.apply_torque_impulse(acceleration.angular)
	if calculate_velocities:
		linear_velocity = GSAIUtils.to_vector3(_body.linear_velocity)
		angular_velocity = _body.angular_velocity


func _set_body(value: RigidBody2D) -> void:
	body = value
	_body_ref = weakref(value)

	_last_position = value.global_position
	_last_orientation = value.rotation

	position = GSAIUtils.to_vector3(_last_position)
	orientation = _last_orientation


func _on_SceneTree_frame() -> void:
	var _body: RigidBody2D = _body_ref.get_ref()
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
			linear_velocity = GSAIUtils.to_vector3(_body.linear_velocity)
			angular_velocity = _body.angular_velocity
