extends Node2D


const COLOR := Color("8fde5d")


func _ready() -> void:
	var _err := get_tree().root.connect("size_changed", self, "_on_SceneTree_size_changed")


func _draw() -> void:
	for b in get_children():
		var extents: Vector2 = b.get_node("CollisionShape2D").shape.extents
		draw_rect(Rect2(b.global_position-extents, extents*2), COLOR)


func _on_SceneTree_size_changed() -> void:
	var size := get_tree().root.size
	for b in get_children():
		var boundary: String = b.name.rsplit("Boundary")[0]
		match boundary:
			"Left":
				b.global_position = Vector2(0, size.y/2)
			"Right":
				b.global_position = Vector2(size.x, size.y/2)
			"Top":
				b.global_position = Vector2(size.x/2, 0)
			"Bottom":
				b.global_position = Vector2(size.x/2, size.y)
	update()
