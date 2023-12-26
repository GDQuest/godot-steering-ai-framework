@tool
extends CollisionShape2D

@export var inner_color := Color(): set = set_inner_color
@export var outer_color := Color(): set = set_outer_color
@export var stroke := 0.0: set = set_stroke


func _draw() -> void:
	draw_circle(Vector2.ZERO, shape.radius + stroke, outer_color)
	draw_circle(Vector2.ZERO, shape.radius, inner_color)


func set_inner_color(val: Color) -> void:
	inner_color = val
	queue_redraw()


func set_outer_color(val: Color) -> void:
	outer_color = val
	queue_redraw()


func set_stroke(val: float) -> void:
	stroke = val
	queue_redraw()
