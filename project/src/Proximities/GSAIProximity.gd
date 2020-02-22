# Base container type that stores data to find the neighbors of an agent.
# category: Proximities
# tags: abstract
extends Reference
class_name GSAIProximity

# The owning agent whose neighbors are found in the group
var agent: GSAISteeringAgent
# The agents who are part of this group and could be potential neighbors
var agents := []


func _init(_agent: GSAISteeringAgent, _agents: Array) -> void:
	self.agent = _agent
	self.agents = _agents


# Returns a number of neighbors based on a `callback` function.
#
# `_find_neighbors` calls `callback` for each agent in the `agents` array and
# adds one to the count if its `callback` returns true.
# tags: virtual
func _find_neighbors(_callback: FuncRef) -> int:
	return 0
