extends GSTProximity
class_name GSTRadiusProximity
# Specifies any agent that is in the specified list as being neighbors with the owner agent if they
# lie within the specified radius.


var radius: = 0.0


func _init(agent: GSTSteeringAgent, agents: Array, radius: float).(agent, agents) -> void:
	self.radius = radius


func find_neighbors(callback: FuncRef) -> int:
	var agent_count: = agents.size()
	var neighbor_count: = 0

	var owner_position: = agent.position
	
	for i in range(agent_count):
		var current_agent: = agents[i] as GSTSteeringAgent

		if current_agent != agent:
			var distance_squared: = owner_position.distance_squared_to(current_agent.position)

			var range_to: = radius + current_agent.bounding_radius

			if distance_squared < range_to * range_to:
				if callback.call_func(current_agent) == true:
					neighbor_count += 1
					continue
	
	return neighbor_count
