extends StaticBody2D
# Draws the bounding box of the static body wall.


var rect: Rect2


func _ready() -> void:
	var extents: Vector2 = $CollisionShape2D.shape.extents
	rect = Rect2(-extents, extents*2)


func _draw() -> void:
	draw_rect(rect, Color.yellowgreen)
