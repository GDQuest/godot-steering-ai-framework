# A specialized steering agent that updates itself every frame so the user does
# not have to using a RigidBody
# @category - Specialized agents
extends GSAISpecializedAgent
class_name GSAIRigidBody3DAgent

# The RigidBody to keep track of
var body: RigidBody setget _set_body

var _last_position: Vector3
var _body_ref: WeakRef

func _init(_body: RigidBody) -> void:
	if not _body.is_inside_tree():
		yield(_body, "ready")
	self.body = _body

	# warning-ignore:return_value_discarded
	_body.get_tree().connect("physics_frame", self, "_on_SceneTree_frame")


# Moves the agent's `body` by target `acceleration`.
# @tags - virtual
func _apply_steering(acceleration: GSAITargetAcceleration, _delta: float) -> void:
	var _body: RigidBody = _body_ref.get_ref()
	if not _body:
		return
		
	_applied_steering = true
	_body.apply_central_impulse(acceleration.linear)
	_body.apply_torque_impulse(Vector3.UP * acceleration.angular)
	if calculate_velocities:
		linear_velocity = _body.linear_velocity
		angular_velocity = _body.angular_velocity.y


func _set_body(value: RigidBody) -> void:
	body = value
	_body_ref = weakref(value)

	_last_position = value.transform.origin
	_last_orientation = value.rotation.y

	position = _last_position
	orientation = _last_orientation


func _on_SceneTree_frame() -> void:
	var _body: RigidBody = _body_ref.get_ref()
	if not _body:
		return
		
	var current_position := _body.transform.origin
	var current_orientation := _body.rotation.y

	position = current_position
	orientation = current_orientation

	if calculate_velocities:
		if _applied_steering:
			_applied_steering = false
		else:
			linear_velocity = _body.linear_velocity
			angular_velocity = _body.angular_velocity.y
