tool
extends CollisionShape2D

export (Color) var inner_color := Color() setget set_inner_color
export (Color) var outer_color := Color() setget set_outer_color
export (float) var stroke := 0.0 setget set_stroke


func _draw() -> void:
	draw_circle(Vector2.ZERO, shape.radius + stroke, outer_color)
	draw_circle(Vector2.ZERO, shape.radius, inner_color)


func set_inner_color(val: Color) -> void:
	inner_color = val
	update()


func set_outer_color(val: Color) -> void:
	outer_color = val
	update()


func set_stroke(val: float) -> void:
	stroke = val
	update()
