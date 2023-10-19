# Determines any agent that is in the specified list as being neighbors with the
# owner agent, regardless of distance.
# @category - Proximities
class_name GSAIInfiniteProximity
extends GSAIProximity


func _init(agent: GSAISteeringAgent, agents: Array) -> void:
	super._init(agent, agents)


# Returns a number of neighbors based on a `callback` function.
#
# `_find_neighbors` calls `callback` for each agent in the `agents` array and
# adds one to the count if its `callback` returns true.
# @tags - virtual
func _find_neighbors(callback: Callable) -> int:
	var neighbor_count := 0
	var agent_count := agents.size()
	for i in range(agent_count):
		var current_agent := agents[i] as GSAISteeringAgent

		if current_agent != agent:
			if callback.call(current_agent):
				neighbor_count += 1

	return neighbor_count
