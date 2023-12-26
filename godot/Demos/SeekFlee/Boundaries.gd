extends Node2D

const COLOR := Color("8fde5d")


func _ready() -> void:
	get_tree().root.connect("size_changed", Callable(self, "_on_SceneTree_size_changed"))
	_on_SceneTree_size_changed()


func _draw() -> void:
	for b in get_children():
		var size: Vector2 = b.get_node("CollisionShape2D").shape.size
		draw_rect(Rect2(b.global_position - size, size * 2), COLOR)


func _on_SceneTree_size_changed() -> void:
	var size := Vector2(
		ProjectSettings["display/window/size/viewport_width"], ProjectSettings["display/window/size/viewport_height"]
	)
	for b in get_children():
		var boundary: String = b.name.rsplit("Boundary")[0]
		match boundary:
			"Left":
				b.global_position = Vector2(0, size.y / 2)
			"Right":
				b.global_position = Vector2(size.x, size.y / 2)
			"Top":
				b.global_position = Vector2(size.x / 2, 0)
			"Bottom":
				b.global_position = Vector2(size.x / 2, size.y)
	queue_redraw()
