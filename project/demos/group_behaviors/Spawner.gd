extends Node2D


export var member: PackedScene


func _ready() -> void:
	var followers: = []
	for i in range(19):
		var follower: = member.instance()
		add_child(follower)
		follower.position += Vector2(rand_range(-60, 60), rand_range(-60, 60))
		followers.append(follower)
		follower.setup(
			owner.max_linear_speed,
			owner.max_linear_accel,
			owner.proximity_radius,
			owner.separation_decay_coefficient,
			owner.cohesion_strength,
			owner.separation_strength
		)
		if i == 0 and owner.show_proximity_radius:
			follower.draw_proximity = true
			follower.update()
	var agents: = []
	for i in followers:
		agents.append(i.agent)
	for i in followers:
		i.proximity.agents = agents


func set_max_linear_speed(value: float) -> void:
	for child in get_children():
		child.agent.max_linear_speed = value


func set_max_linear_accel(value: float) -> void:
	for child in get_children():
		child.agent.max_linear_acceleration = value


func set_proximity_radius(value: float) -> void:
	for child in get_children():
		child.proximity.radius = value
		if child == get_child(0):
			child.update()


func set_show_proximity_radius(value: bool) -> void:
	get_child(0).draw_proximity = value
	get_child(0).update()


func set_separation_decay_coef(value: float) -> void:
	for child in get_children():
		child.separation.decay_coefficient = value


func set_cohesion_strength(value: float) -> void:
	for child in get_children():
		child.blend.get_behavior_at(1).weight = value


func set_separation_strength(value: float) -> void:
	for child in get_children():
		child.blend.get_behavior_at(0).weight = value
