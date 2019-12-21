class_name GSTTargetAcceleration
"""
A linear and angular amount of acceleration.
"""


var linear: = Vector3.ZERO
var angular: = 0.0


func set_zero() -> void:
	linear.x = 0.0
	linear.y = 0.0
	linear.z = 0.0
	angular = 0.0


func add_scaled_accel(accel: GSTTargetAcceleration, scalar: float) -> void:
	linear += accel.linear * scalar
	angular += accel.angular * scalar


func get_squared_magnitude() -> float:
	return linear.length_squared() + angular * angular


func get_magnitude() -> float:
	return sqrt(get_squared_magnitude())
