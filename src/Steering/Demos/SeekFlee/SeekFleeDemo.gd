extends Node2D
"""
Access helper class for children to access window boundaries.
"""


var camera_boundaries: Rect2


func _init() -> void:
	camera_boundaries = Rect2(
		Vector2.ZERO,
		 Vector2(ProjectSettings["display/window/size/width"], ProjectSettings["display/window/size/height"])
		)
