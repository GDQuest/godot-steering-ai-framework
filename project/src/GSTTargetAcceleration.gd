class_name GSTTargetAcceleration
# A desired linear and angular amount of acceleration requested by the steering system.


# The linear amount of acceleration
var linear := Vector3.ZERO
# The angular amount of acceleration
var angular := 0.0


# Sets the linear and angular components to 0
func set_zero() -> void:
	linear.x = 0.0
	linear.y = 0.0
	linear.z = 0.0
	angular = 0.0


# Adds `accel`'s components, multiplied by `scalar`, to this one.
func add_scaled_accel(accel: GSTTargetAcceleration, scalar: float) -> void:
	linear += accel.linear * scalar
	angular += accel.angular * scalar


# Returns the squared magnitude of the linear and angular components
func get_magnitude_squared() -> float:
	return linear.length_squared() + angular * angular


# Returns the magnitude of the linear and angular components
func get_magnitude() -> float:
	return sqrt(get_magnitude_squared())
