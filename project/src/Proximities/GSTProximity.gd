extends Reference
class_name GSTProximity
# Defines a way to determine any agent that is in the specified list as being neighbors with the
# owner agent.


var agent: GSTSteeringAgent
var agents := []


func _init(agent: GSTSteeringAgent, agents: Array) -> void:
	self.agent = agent
	self.agents = agents


func find_neighbors(callback: FuncRef) -> int:
	return 0
