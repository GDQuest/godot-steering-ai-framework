extends Camera

var target: Spatial

onready var ray := $RayCast


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_set_target_position(event.position)


func setup(_target: Spatial) -> void:
	self.target = _target
	_set_target_position(get_viewport().get_mouse_position())


func _set_target_position(position: Vector2) -> void:
	var to = project_local_ray_normal(position) * 10000
	ray.cast_to = to
	ray.force_raycast_update()
	if ray.is_colliding():
		var point = ray.get_collision_point()
		target.transform.origin = point
