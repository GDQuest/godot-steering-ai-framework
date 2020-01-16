extends GSTSteeringBehavior
class_name GSTGroupBehavior
# Extended behavior that features a Proximity group for group-based behaviors.


var proximity: GSTProximity

var _callback := funcref(self, "report_neighbor")


func _init(agent: GSTSteeringAgent, proximity: GSTProximity).(agent) -> void:
	self.proximity = proximity


func report_neighbor(neighbor: GSTSteeringAgent) -> bool:
	return false
