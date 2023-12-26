extends Camera3D

var target: Node3D

@onready var ray : RayCast3D = $RayCast3D


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEventMouseMotion:
		_set_target_position(event.position)


func setup(_target: Node3D) -> void:
	self.target = _target
	_set_target_position(get_viewport().get_mouse_position())


func _set_target_position(pos: Vector2) -> void:
	var to = project_local_ray_normal(pos) * 10000
	ray.target_position = to
	ray.force_raycast_update()
	if ray.is_colliding():
		var point = ray.get_collision_point()
		target.global_position = point
