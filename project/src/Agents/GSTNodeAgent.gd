# A base class for a specialized steering agent that updates itself every frame
# so the user does not have to.
extends GSTSteeringAgent
class_name GSTNodeAgent


enum MovementType { SLIDE, COLLIDE, POSITION }

enum BodyType { NODE, KINEMATIC, RIGID }


# If `true`, will update before `_physics_process` is called. If `false`, will
# update before `_process` is called.
# 
# `KinematicBody`, `KinematicBody2D`, `RigidBody`, and `RigidBody2D` should
# always use `_physics_process`.
var use_physics := true setget _set_use_physics

# If `true`, will calculate linear and angular velocities based on the previous
# frame. When `false`, the user must keep those values updated.
var calculate_velocities := true

# If `true` and velocities and `calculate_velocities` is true, will interpolate
# the current linear velocity towards 0 by the `linear_drag_percentage` value.
# Does not apply to `RigidBody` and `RigidBody2D` nodes.
var apply_linear_drag := true

# If `true` and velocities and `calculate_velocities` is true, will interpolate
# the current angular velocity towards 0 by the `angular_drag_percentage` value.
# Does not apply to `RigidBody` and `RigidBody2D` nodes.
var apply_angular_drag := true

# The percentage between the current linear velocity and 0 to interpolate by if
# `calculate_velocities` and `apply_linear_drag` are true.
# Does not apply to `RigidBody` and `RigidBody2D` nodes.
var linear_drag_percentage := 0.0

# The percentage between the current angular velocity and 0 to interpolate by if
# `calculate_velocities` and `apply_angular_drag` are true.
# Does not apply to `RigidBody` and `RigidBody2D` nodes.
var angular_drag_percentage := 0.0

# Determines how linear movement occurs if the body is a `KinematicBody` or
# `KinematicBody2D`.
# 
# SLIDE uses `move_and_slide`
# COLLIDE uses `move_and_collide`
# POSITION changes global position directly
var kinematic_movement_type: int = MovementType.SLIDE

var _last_orientation: float
var _body_type: int
var _applied_steering := false


# Moves the agent's body by target `acceleration`.
# tags: virtual
func _apply_steering(acceleration: GSTTargetAcceleration, delta: float) -> void:
	pass


func _apply_sliding_steering(accel: Vector3) -> void:
	pass


func _apply_collide_steering(accel: Vector3, delta: float) -> void:
	pass


func _apply_normal_steering(accel: Vector3, delta: float) -> void:
	pass


func _apply_orientation_steering(angular_acceleration: float, delta: float) -> void:
	pass


func _set_use_physics(value: bool) -> void:
	use_physics = value
