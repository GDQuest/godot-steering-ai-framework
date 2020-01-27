extends GSTSteeringBehavior
class_name GSTGroupBehavior
# Base type for group-based steering behaviors.


# Container to find neighbors of the agent and apply a group behavior.
var proximity: GSTProximity

var _callback := funcref(self, "report_neighbor")


func _init(agent: GSTSteeringAgent, proximity: GSTProximity).(agent) -> void:
	self.proximity = proximity


# Internal callback for the behavior to define whether or not a member is
# relevant
func report_neighbor(neighbor: GSTSteeringAgent) -> bool:
	return false
