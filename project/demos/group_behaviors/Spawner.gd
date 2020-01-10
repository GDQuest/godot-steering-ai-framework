extends Node2D


export var member: PackedScene


func _ready() -> void:
	var followers: = []
	for i in range(19):
		var follower: = member.instance()
		add_child(follower)
		follower.position += Vector2(rand_range(-60, 60), rand_range(-60, 60))
		followers.append(follower)
	var agents: = []
	for i in followers:
		agents.append(i.agent)
	for i in followers:
		i.proximity.agents = agents
