# Determines any agent that is in the specified list as being neighbors with the owner agent if
# they lie within the specified radius.
# category: Proximities
extends GSAIProximity
class_name GSAIRadiusProximity

# The radius around the owning agent to find neighbors in
var radius := 0.0

var _last_frame := 0
var _scene_tree: SceneTree


func _init(agent: GSAISteeringAgent, agents: Array, _radius: float).(agent, agents) -> void:
	self.radius = _radius
	_scene_tree = Engine.get_main_loop()


# Returns a number of neighbors based on a `callback` function.
#
# `_find_neighbors` calls `callback` for each agent in the `agents` array that lie within
# the radius around the owning agent and adds one to the count if its `callback` returns true.
# tags: virtual
func _find_neighbors(callback: FuncRef) -> int:
	var agent_count := agents.size()
	var neighbor_count := 0

	var current_frame := _scene_tree.get_frame() if _scene_tree else -_last_frame
	if current_frame != _last_frame:
		_last_frame = current_frame

		var owner_position := agent.position

		for i in range(agent_count):
			var current_agent := agents[i] as GSAISteeringAgent

			if current_agent != agent:
				var distance_squared := owner_position.distance_squared_to(current_agent.position)

				var range_to := radius + current_agent.bounding_radius

				if distance_squared < range_to * range_to:
					if callback.call_func(current_agent):
						current_agent.is_tagged = true
						neighbor_count += 1
						continue

			current_agent.is_tagged = false
	else:
		for i in range(agent_count):
			var current_agent = agents[i] as GSAISteeringAgent

			if current_agent != agent and current_agent.is_tagged:
				if callback.call_func(current_agent):
					neighbor_count += 1

	return neighbor_count
