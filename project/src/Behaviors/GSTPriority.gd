# Container for multiple behaviors that returns the result of the first child
# behavior with non-zero acceleration.
class_name GSTPriority
extends GSTSteeringBehavior


var _behaviors := []

# The index of the last behavior the container prioritized.
var last_selected_index: int
# If a behavior's acceleration is lower than this threshold, the container
# considers it has an acceleration of zero.
var zero_threshold: float


func _init(agent: GSTSteeringAgent, zero_threshold := 0.001).(agent) -> void:
	self.zero_threshold = zero_threshold


# Appends a steering behavior as a child of this container.
func add(behavior: GSTSteeringBehavior) -> void:
	_behaviors.append(behavior)


# Returns the behavior at the position in the pool referred to by `index`, or
# `null` if no behavior was found.
func get_behavior_at(index: int) -> GSTSteeringBehavior:
	if _behaviors.size() > index:
		return _behaviors[index]
	printerr("Tried to get index " + str(index) + " in array of size " + str(_behaviors.size()))
	return null


func _calculate_steering(accel: GSTTargetAcceleration) -> GSTTargetAcceleration:
	var threshold_squared := zero_threshold * zero_threshold

	last_selected_index = -1

	var size := _behaviors.size()

	if size > 0:
		for i in range(size):
			last_selected_index = i
			var behavior: GSTSteeringBehavior = _behaviors[i]
			behavior.calculate_steering(accel)

			if accel.get_magnitude_squared() > threshold_squared:
				break
	else:
		accel.set_zero()

	return accel
