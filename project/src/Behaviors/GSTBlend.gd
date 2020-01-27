class_name GSTBlend
extends GSTSteeringBehavior
# Blends multiple steering behaviors into one, and returns acceleration combining all of them.
# 
# Each behavior is associated with a weight - a modifier by which the result will be multiplied by,
# then added to a total acceleration.
# 
# Each behavior is stored internally as a `Dictionary` with a `behavior` key with a value of type
# `GSTSteeringBehavior` and a `weight` key with a value of type float.


var _behaviors := []
var _accel := GSTTargetAcceleration.new()


func _init(agent: GSTSteeringAgent).(agent) -> void:
	pass


# Adds a behavior to the next index and gives it a `weight` by which its results will be multiplied
func add(behavior: GSTSteeringBehavior, weight: float) -> void:
	behavior.agent = agent
	_behaviors.append({behavior = behavior, weight = weight})


# Returns the behavior at the specified `index`. Returns an empty `Dictionary` if none was found.
func get_behavior_at(index: int) -> Dictionary:
	if _behaviors.size() > index:
		return _behaviors[index]
	printerr("Tried to get index " + str(index) + " in array of size " + str(_behaviors.size()))
	return {}


func _calculate_steering(blended_accel: GSTTargetAcceleration) -> GSTTargetAcceleration:
	blended_accel.set_zero()
	
	for i in range(_behaviors.size()):
		var bw: Dictionary = _behaviors[i]
		bw.behavior.calculate_steering(_accel)
		
		blended_accel.add_scaled_accel(_accel, bw.weight)
	
	blended_accel.linear = GSTUtils.clampedv3(blended_accel.linear, agent.linear_acceleration_max)
	blended_accel.angular = clamp(
			blended_accel.angular,
			-agent.angular_acceleration_max,
			agent.angular_acceleration_max
	)
	
	return blended_accel
