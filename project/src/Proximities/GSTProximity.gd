extends Reference
class_name GSTProximity
# Base container type that stores data to find the neighbors of an agent.


var agent: GSTSteeringAgent
var agents := []


func _init(agent: GSTSteeringAgent, agents: Array) -> void:
	self.agent = agent
	self.agents = agents


func find_neighbors(callback: FuncRef) -> int:
	return 0
