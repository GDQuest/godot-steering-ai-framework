# A specialized steering agent that updates itself every frame so the user does
# not have to using a RigidBody
extends GSAISpecializedAgent
class_name GSAIRigidBody3DAgent


# The RigidBody to keep track of
var body: RigidBody setget _set_body

var _last_position: Vector3


func _init(_body: RigidBody) -> void:
	if not _body.is_inside_tree():
		yield(_body, "ready")
	
	self.body = _body
	# warning-ignore:return_value_discarded
	self.body.get_tree().connect("physics_frame", self, "_on_SceneTree_frame")
	


# Moves the agent's `body` by target `acceleration`.
# tags: virtual
func _apply_steering(acceleration: GSAITargetAcceleration, _delta: float) -> void:
	_applied_steering = true
	body.apply_central_impulse(acceleration.linear)
	body.apply_torque_impulse(Vector3.UP * acceleration.angular)
	if calculate_velocities:
		linear_velocity = body.linear_velocity
		angular_velocity = body.angular_velocity.y


func _set_body(value: RigidBody) -> void:
	body = value
	
	_last_position = body.global_position
	_last_orientation = body.rotation.y
	
	position = _last_position
	orientation = _last_orientation


func _on_body_ready() -> void:
	# warning-ignore:return_value_discarded
	body.get_tree().connect("physics_frame", self, "_on_SceneTree_frame")
	_set_body(body)


func _on_SceneTree_frame() -> void:
	var current_position: Vector3 = body.global_position
	var current_orientation: float = body.rotation.y
	
	position = current_position
	orientation = current_orientation
	
	if calculate_velocities:
		if _applied_steering:
			_applied_steering = false
		else:
			linear_velocity = body.linear_velocity
			angular_velocity = body.angular_velocity.y
