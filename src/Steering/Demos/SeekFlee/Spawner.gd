extends Node2D
"""
Instantiates and configures a number of agent scenes within the level boundaries.
"""


onready var player_agent: AgentLocation = owner.get_node("Player").player_agent


export(PackedScene) var agent_scene: PackedScene
export var agent_count: = 10
export var min_speed: = 50.0
export var max_speed: = 125.0
export var agent_color: = Color.blue


func _ready() -> void:
	var boundaries: Rect2 = owner.camera_boundaries
	randomize()
	for i in range(agent_count):
		var new_pos: = Vector2(
			rand_range(-boundaries.size.x/2, boundaries.size.x/2), 
			rand_range(-boundaries.size.y/2, boundaries.size.y/2)
		)
		var agent: = agent_scene.instance()
		agent.global_position = new_pos
		agent.player_agent = player_agent
		agent.speed = rand_range(min_speed, max_speed)
		agent.color = agent_color
		add_child(agent)
