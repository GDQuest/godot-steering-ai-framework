extends Node
# Access helper class for children to access window boundaries.

enum Mode { FLEE, SEEK }

@export var behavior_mode := Mode.SEEK: set = set_behavior_mode
@export_range(0, 1000, 30) var linear_speed_max := 200.0: set = set_linear_speed_max
@export_range(0, 2000, 40) var linear_accel_max := 10.0: set = set_linear_accel_max
@export var player_speed := 600.0: set = set_player_speed

var camera_boundaries: Rect2

@onready var player: CharacterBody2D = $Player
@onready var spawner: Node2D = $Spawner


func _ready() -> void:
	get_tree().root.content_scale_mode = Window.CONTENT_SCALE_MODE_CANVAS_ITEMS
	get_tree().root.content_scale_aspect = Window.CONTENT_SCALE_ASPECT_EXPAND
	
	camera_boundaries = Rect2(
		Vector2.ZERO,
		Vector2(
			ProjectSettings["display/window/size/viewport_width"],
			ProjectSettings["display/window/size/viewport_height"]
		)
	)

	var rng := RandomNumberGenerator.new()
	rng.randomize()

	player.speed = player_speed

	for i in range(spawner.entity_count):
		var new_pos := Vector2(
			rng.randf_range(0, camera_boundaries.size.x),
			rng.randf_range(0, camera_boundaries.size.y)
		)
		var entity: CharacterBody2D = spawner.Entity.instantiate()
		entity.global_position = new_pos
		entity.player_agent = player.agent
		entity.start_speed = linear_speed_max
		entity.start_accel = linear_accel_max
		entity.use_seek = behavior_mode == Mode.SEEK
		spawner.add_child(entity)


func set_behavior_mode(mode: int) -> void:
	behavior_mode = mode
	if not is_inside_tree():
		return

	match mode:
		Mode.SEEK:
			for child in spawner.get_children():
				child.use_seek = true
		Mode.FLEE:
			for child in spawner.get_children():
				child.use_seek = false


func set_linear_speed_max(value: float) -> void:
	linear_speed_max = value
	if not is_inside_tree():
		return

	for child in spawner.get_children():
		child.agent.linear_speed_max = value


func set_linear_accel_max(value: float) -> void:
	linear_accel_max = value
	if not is_inside_tree():
		return

	for child in spawner.get_children():
		child.agent.linear_acceleration_max = value


func set_player_speed(value: float) -> void:
	player_speed = value
	if not is_inside_tree():
		return

	player.speed = player_speed
