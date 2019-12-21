extends GSTSteeringBehavior
class_name GSTBlend
"""
Blends multiple steering behaviors into one, and returns acceleration combining all of them.

Each behavior is associated with a weight - a modifier by which the result will be multiplied by,
then added to a total acceleration.
"""


onready var _behaviors: = []
onready var _accel: = GSTTargetAcceleration.new()


func _init(agent: GSTSteeringAgent).(agent) -> void:
	pass


func add(behavior: GSTSteeringBehavior, weight: float) -> void:
	behavior.agent = agent
	_behaviors.append(GSTBehaviorAndWeight.new(behavior, weight))


func get_behavior_at(index: int) -> GSTBehaviorAndWeight:
	if _behaviors.size() > index:
		return _behaviors[index]
	printerr("Tried to get index " + str(index) + " in array of size " + str(_behaviors.size()))
	return null


func _calculate_steering(blended_accel: GSTTargetAcceleration) -> GSTTargetAcceleration:
	blended_accel.set_zero()
	
	for i in range(_behaviors.size()):
		var bw: GSTBehaviorAndWeight = _behaviors[i]
		bw.behavior.calculate_steering(_accel)
		
		blended_accel.add_scaled_accel(_accel, bw.weight)
	
	blended_accel.linear = Utils.clampedv3(blended_accel.linear, agent.max_linear_acceleration)
	if blended_accel.angular > agent.max_angular_acceleration:
		blended_accel.angular = agent.max_angular_acceleration
	
	return blended_accel


class GSTBehaviorAndWeight:
	var behavior: GSTSteeringBehavior
	var weight: float
	
	func _init(behavior: GSTSteeringBehavior, weight: float) -> void:
		self.behavior = behavior
		self.weight = weight
