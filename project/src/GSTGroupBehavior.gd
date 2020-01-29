# Base type for group-based steering behaviors.
class_name GSTGroupBehavior
extends GSTSteeringBehavior


# Container to find neighbors of the agent and calculate group behavior.
var proximity: GSTProximity

var _callback := funcref(self, "_report_neighbor")


func _init(agent: GSTSteeringAgent, proximity: GSTProximity).(agent) -> void:
	self.proximity = proximity


# Internal callback for the behavior to define whether or not a member is
# relevant
func _report_neighbor(neighbor: GSTSteeringAgent) -> bool:
	return false
