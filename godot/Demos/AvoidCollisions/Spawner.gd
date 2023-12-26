extends Node2D

@export var avoider_template: PackedScene
@export var inner_color := Color()
@export var outer_color := Color()
@export var agent_count := 60

var boundaries: Vector2


func _ready() -> void:
	boundaries = Vector2(
		ProjectSettings["display/window/size/viewport_width"], ProjectSettings["display/window/size/viewport_height"]
	)
	var rng := RandomNumberGenerator.new()
	var avoiders := []
	var avoider_agents := []
	for i in range(agent_count):
		var avoider := avoider_template.instantiate()
		add_child(avoider)
		avoider.setup(
			owner.linear_speed_max,
			owner.linear_acceleration_max,
			owner.proximity_radius,
			boundaries.x,
			boundaries.y,
			true if i == 0 and owner.draw_proximity else false,
			rng
		)
		avoider_agents.append(avoider.agent)
		avoider.set_random_nonoverlapping_position(avoiders, 16)
		if i == 0:
			avoider.collision.inner_color = inner_color
			avoider.collision.outer_color = outer_color
		avoiders.append(avoider)
		if i % 10 == 0:
			await get_tree().process_frame
	for child in get_children():
		child.set_proximity_agents(avoider_agents)


func _physics_process(_delta: float) -> void:
	for child in get_children():
		child.global_position = child.global_position.posmodv(boundaries)


func set_linear_speed_max(value: float) -> void:
	for child in get_children():
		child.agent.linear_speed_max = value


func set_linear_accel_max(value: float) -> void:
	for child in get_children():
		child.agent.linear_acceleration_max = value


func set_proximity_radius(value: float) -> void:
	for child in get_children():
		child.proximity.radius = value
	get_child(0).update()


func set_draw_proximity(value: bool) -> void:
	var child := get_child(0)
	child.draw_proximity = value
	child.update()
