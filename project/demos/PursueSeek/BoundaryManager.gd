extends Node2D
# Wraps the ships' positions around the world border, and controls their rendering clones.


var _world_bounds: Vector2


func _ready() -> void:
	_world_bounds = Vector2(
			ProjectSettings["display/window/size/width"],
			ProjectSettings["display/window/size/height"]
	)


func _physics_process(delta: float) -> void:
	for ship in get_children():
		ship.position = ship.position.posmodv(_world_bounds)
