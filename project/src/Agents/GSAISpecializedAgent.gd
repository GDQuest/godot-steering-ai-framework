# A base class for a specialized steering agent that updates itself every frame
# so the user does not have to. All other specialized agents derive from this.
# category: Specialized agents
# tags: abstract
extends GSAISteeringAgent
class_name GSAISpecializedAgent

# If `true`, calculates linear and angular velocities based on the previous
# frame. When `false`, the user must keep those values updated.
var calculate_velocities := true

# If `true`, interpolates the current linear velocity towards 0 by the 
# `linear_drag_percentage` value.
# Does not apply to `RigidBody` and `RigidBody2D` nodes.
var apply_linear_drag := true

# If `true`, interpolates the current angular velocity towards 0 by the
# `angular_drag_percentage` value.
# Does not apply to `RigidBody` and `RigidBody2D` nodes.
var apply_angular_drag := true

# The percentage between the current linear velocity and 0 to interpolate by if
# `apply_linear_drag` is true.
# Does not apply to `RigidBody` and `RigidBody2D` nodes.
var linear_drag_percentage := 0.0

# The percentage between the current angular velocity and 0 to interpolate by if
# `apply_angular_drag` is true.
# Does not apply to `RigidBody` and `RigidBody2D` nodes.
var angular_drag_percentage := 0.0

var _last_orientation: float
var _applied_steering := false


# Moves the agent's body by target `acceleration`.
# tags: virtual
func _apply_steering(_acceleration: GSAITargetAcceleration, _delta: float) -> void:
	pass
