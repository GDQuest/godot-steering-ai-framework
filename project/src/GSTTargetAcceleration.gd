extends Reference
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
