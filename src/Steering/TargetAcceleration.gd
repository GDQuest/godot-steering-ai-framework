extends Reference
class_name TargetAcceleration


var linear: = Vector3.ZERO
var angular: = 0.0


func set_zero() -> TargetAcceleration:
	linear.x = 0.0
	linear.y = 0.0
	linear.z = 0.0
	angular = 0.0
	return self
