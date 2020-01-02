extends StaticBody2D
# Draws the bounding box of the static body wall.


var rect: Rect2


func _ready() -> void:
	var extents: = ($CollisionShape2D.shape as RectangleShape2D).extents
	rect = Rect2(-extents, extents*2)


func _draw() -> void:
	draw_rect(rect, Color.yellowgreen)
