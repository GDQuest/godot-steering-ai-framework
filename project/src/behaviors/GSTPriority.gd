extends GSTSteeringBehavior
class_name GSTPriority
# Contains multiple steering behaviors and returns only the result of the first that has a non-zero
 # acceleration.


onready var _behaviors: = []

var last_selected_index: int
var threshold_for_zero: float


func _init(agent: GSTSteeringAgent, threshold_for_zero: = 0.001).(agent) -> void:
	self.threshold_for_zero = threshold_for_zero


func add(behavior: GSTSteeringBehavior) -> void:
	_behaviors.append(behavior)


func get_behavior_at(index: int) -> GSTSteeringBehavior:
	if _behaviors.size() > index:
		return _behaviors[index]
	printerr("Tried to get index " + str(index) + " in array of size " + str(_behaviors.size()))
	return null


func _calculate_steering(accel: GSTTargetAcceleration) -> GSTTargetAcceleration:
	var threshold_squared: = threshold_for_zero * threshold_for_zero
	
	last_selected_index = -1
	
	var size: = _behaviors.size()
	
	if size > 0:
		for i in range(size):
			last_selected_index = i
			var behavior: GSTSteeringBehavior = _behaviors[i]
			behavior.calculate_steering(accel)
			
			if accel.get_squared_magnitude() > threshold_squared:
				break
	else:
		accel.set_zero()
	
	return accel
