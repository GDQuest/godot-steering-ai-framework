extends Node2D


export var avoider_template: PackedScene
export var normal_color := Color()
export var highlight_color := Color()

var boundaries: Vector2


func _ready() -> void:
	boundaries = Vector2(ProjectSettings["display/window/size/width"],
			ProjectSettings["display/window/size/height"])
	var rng: = RandomNumberGenerator.new()
	var avoiders := []
	var avoider_agents := []
	for i in range(60):
		var avoider := avoider_template.instance()
		add_child(avoider)
		avoider.setup(
				owner.max_linear_speed,
				owner.max_linear_acceleration,
				owner.proximity_radius,
				boundaries.x,
				boundaries.y,
				true if i == 0 and owner.draw_proximity else false,
				rng
		)
		avoider_agents.append(avoider.agent)
		avoider.set_random_nonoverlapping_position(avoiders, 16)
		avoider.sprite.modulate = normal_color if i != 0 or not owner.draw_proximity else highlight_color
		avoiders.append(avoider)
	for child in get_children():
		child.set_proximity_agents(avoider_agents)


func _physics_process(delta: float) -> void:
	for child in get_children():
		child.global_position = child.global_position.posmodv(boundaries)


func set_max_linear_speed(value: float) -> void:
	for child in get_children():
		child.agent.max_linear_speed = value


func set_max_linear_accel(value: float) -> void:
	for child in get_children():
		child.agent.max_linear_acceleration = value


func set_proximity_radius(value: float) -> void:
	for child in get_children():
		child.proximity.radius = value
	get_child(0).update()


func set_draw_proximity(value: bool) -> void:
	var child := get_child(0)
	child.draw_proximity = value
	if not value:
		child.sprite.modulate = normal_color
	else:
		child.sprite.modulate = highlight_color
	child.update()
