extends Reference
class_name GSTProximity
# Defines an area that is used by group behaviors to find and process the owner's neighbors.


var agent: GSTSteeringAgent
var agents: = []


func _init(agent: GSTSteeringAgent, agents: Array) -> void:
    self.agent = agent
    self.agents = agents


func find_neighbors(callback: FuncRef) -> int:
    return 0