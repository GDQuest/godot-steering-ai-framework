# Base container type that stores data to find the neighbors of an agent.
extends Reference
class_name GSTProximity


# The owning agent whose neighbors are found in the group
var agent: GSTSteeringAgent
# The agents who are part of this group and could be potential neighbors
var agents := []


func _init(agent: GSTSteeringAgent, agents: Array) -> void:
	self.agent = agent
	self.agents = agents


# Returns a number of neighbors based on a `callback` function.
#
# `_find_neighbors` calls `callback` for each agent in the `agents` array and
# adds one to the count if its `callback` returns true.
func _find_neighbors(callback: FuncRef) -> int:
	return 0
