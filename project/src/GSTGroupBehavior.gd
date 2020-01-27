extends GSTSteeringBehavior
class_name GSTGroupBehavior
# Extended behavior that features a Proximity group for group-based behaviors.


# The group area definition that will be used to find the owning agent's neighbors
var proximity: GSTProximity

var _callback := funcref(self, "report_neighbor")


# Initializes the behavior with its owning `agent` and group's `proximity`
func _init(agent: GSTSteeringAgent, proximity: GSTProximity).(agent) -> void:
	self.proximity = proximity


# Internal callback for the behavior to define whether or not a member is relevant
func report_neighbor(neighbor: GSTSteeringAgent) -> bool:
	return false
