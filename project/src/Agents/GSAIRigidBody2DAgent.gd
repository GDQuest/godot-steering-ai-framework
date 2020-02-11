# A specialized steering agent that updates itself every frame so the user does
# not have to using a RigidBody2D
extends GSAISpecializedAgent
class_name GSAIRigidBody2DAgent


# The RigidBody2D to keep track of
var body: RigidBody2D setget _set_body

var _last_position: Vector2


func _init(_body: RigidBody2D) -> void:
	if not _body.is_inside_tree():
		yield(_body, "ready")
	
	self.body = _body


# Moves the agent's `body` by target `acceleration`.
# tags: virtual
func _apply_steering(acceleration: GSAITargetAcceleration, _delta: float) -> void:
	_applied_steering = true
	body.apply_central_impulse(GSAIUtils.to_vector2(acceleration.linear))
	body.apply_torque_impulse(acceleration.angular)
	if calculate_velocities:
		linear_velocity = GSAIUtils.to_vector3(body.linear_velocity)
		angular_velocity = body.angular_velocity


func _set_body(value: RigidBody2D) -> void:
	body = value
	
	_last_position = body.global_position
	_last_orientation = body.rotation
	
	position = GSAIUtils.to_vector3(_last_position)
	orientation = _last_orientation


func _on_body_ready() -> void:
	# warning-ignore:return_value_discarded
	body.get_tree().connect("physics_frame", self, "_on_SceneTree_frame")
	_set_body(body)


func _on_SceneTree_frame() -> void:
	var current_position: Vector2 = body.global_position
	var current_orientation: float = body.rotation
	
	position = GSAIUtils.to_vector3(current_position)
	orientation = current_orientation
	
	if calculate_velocities:
		if _applied_steering:
			_applied_steering = false
		else:
			linear_velocity = GSAIUtils.to_vector3(body.linear_velocity)
			angular_velocity = body.angular_velocity
