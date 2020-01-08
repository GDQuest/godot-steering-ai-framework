extends GSTProximity
class_name GSTInfiniteProximity
# Specifies any agent that is in the specified list as being neighbors with the owner agent.


func _init(agent: GSTSteeringAgent, agents: Array).(agent, agents) -> void:
	pass


func find_neighbors(callback: FuncRef) -> int:
	var neighbor_count: = 0
	var agent_count: = agents.size()
	for i in range(agent_count):
		var current_agent: = agents[i] as GSTSteeringAgent

		if current_agent != agent:
			if callback.call_func(current_agent):
				neighbor_count += 1
	
	return neighbor_count
