extends Node2D
"""
Access helper class for children to access window boundaries.
"""


onready var player: KinematicBody2D = $Player
onready var spawner: Node2D = $Spawner
onready var gui: = $GUI

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
		entity.speed = rng.randf_range(spawner.min_speed, spawner.max_speed)
		entity.color = spawner.entity_color
		gui.connect("mode_changed", entity, "_on_GUI_mode_changed")
		spawner.add_child(entity)
