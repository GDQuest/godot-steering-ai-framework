extends Node2D
# Access helper class for children to access window boundaries.


enum Mode { FLEE, SEEK }

export(Mode) var behavior_mode: = Mode.SEEK setget set_behavior_mode
export(float, 0, 2000, 40) var max_linear_speed: = 200.0 setget set_max_linear_speed
export(float, 0, 500, 0.5) var max_linear_accel: = 10.0 setget set_max_linear_accel

onready var player: KinematicBody2D = $Player
onready var spawner: Node2D = $Spawner

var camera_boundaries: Rect2


func _init() -> void:
	camera_boundaries = Rect2(
		Vector2.ZERO,
		Vector2(
			ProjectSettings["display/window/size/width"],
			ProjectSettings["display/window/size/height"]
			)
		)


func _ready() -> void:
	var rng: = RandomNumberGenerator.new()
	rng.randomize()
	
	for i in range(spawner.entity_count):
		var new_pos: = Vector2(
				rng.randf_range(-camera_boundaries.size.x/2, camera_boundaries.size.x/2),
				rng.randf_range(-camera_boundaries.size.y/2, camera_boundaries.size.y/2)
		)
		var entity: KinematicBody2D = spawner.Entity.instance()
		entity.global_position = new_pos
		entity.player_agent = player.agent
		entity.start_speed = max_linear_speed
		entity.start_accel = max_linear_accel
		spawner.add_child(entity)


func set_behavior_mode(mode: int) -> void:
	behavior_mode = mode
	
	if spawner:
		match mode:
			Mode.SEEK:
				for child in spawner.get_children():
					child.use_seek = true
			Mode.FLEE:
				for child in spawner.get_children():
					child.use_seek = false


func set_max_linear_speed(value: float) -> void:
	max_linear_speed = value
	
	if spawner:
		for child in spawner.get_children():
			child.agent.max_linear_speed = value


func set_max_linear_accel(value: float) -> void:
	max_linear_accel = value
	
	if spawner:
		for child in spawner.get_children():
			child.agent.max_linear_acceleration = value
