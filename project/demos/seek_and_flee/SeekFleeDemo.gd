extends Node2D
# Access helper class for children to access window boundaries.


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
	
	gui.max_accel.value = spawner.max_accel
	gui.max_speed.value = spawner.max_speed
	
	for i in range(spawner.entity_count):
		var new_pos: = Vector2(
				rng.randf_range(-camera_boundaries.size.x/2, camera_boundaries.size.x/2),
				rng.randf_range(-camera_boundaries.size.y/2, camera_boundaries.size.y/2)
		)
		var entity: KinematicBody2D = spawner.Entity.instance()
		entity.global_position = new_pos
		entity.player_agent = player.agent
		entity.start_speed = spawner.max_speed
		entity.start_accel = spawner.max_accel
		gui.connect("mode_changed", entity, "_on_GUI_mode_changed")
		gui.connect("accel_changed", entity, "_on_GUI_accel_changed")
		gui.connect("speed_changed", entity, "_on_GUI_speed_changed")
		spawner.add_child(entity)
